import { assertEquals, callReadOnlyFunction } from '@hirosystems/clarinet-sdk';

const contractName = 'savings-tracker';

test('get-savings should return 100', async () => {
  const result = await callReadOnlyFunction(contractName, "get-savings", [], 0);
  assertEquals(result, 100);
});

