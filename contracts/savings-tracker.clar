(define-map savings-goals
  { wallet: principal }
  { goal: uint, saved: uint })

;; Function to set the goal amount
(define-public (set-goal (goal-amount uint))
  (begin
    ;; Ensure the goal is greater than zero
    (asserts! (> goal-amount u0) (err "Goal amount must be greater than zero"))
    
    ;; Prevent setting a new goal if one already exists for this wallet
    (let ((existing-goal (map-get? savings-goals { wallet: tx-sender })))
      (match existing-goal
        (some existing-data (err "Goal already set. Use deposit function to add to your goal."))
        (none
          ;; If no goal exists, set the goal
          (map-set savings-goals
            { wallet: tx-sender }
            { goal: goal-amount, saved: u0 })
          (ok "Goal set successfully"))
      )
    )
  )
)

;; Function to make a deposit towards the savings goal
(define-public (deposit (amount uint))
  (begin
    ;; Ensure deposit amount is greater than zero
    (asserts! (> amount u0) (err "Deposit amount must be greater than zero"))
    
    ;; Get the existing goal for the sender
    (let ((entry (map-get? savings-goals { wallet: tx-sender })))
      
      (match entry
        (some { goal: goal-val, saved: saved-val })
        (let ((new-saved (+ saved-val amount)))
          ;; Update the saved amount with the new deposit
          (map-set savings-goals
            { wallet: tx-sender }
            { goal: goal-val, saved: new-saved })
          (ok "Deposit successful"))
        
        (none (err "No goal set. Please set a goal first."))
      )
    )
  )
)

;; Function to check progress of savings
(define-public (check-progress)
  (let ((entry (map-get? savings-goals { wallet: tx-sender })))
    
    (match entry
      (some { goal: goal-val, saved: saved-val })
      (ok { goal: goal-val, saved: saved-val })
      
      (none (err "No goal found for this wallet"))
    )
  )
)
