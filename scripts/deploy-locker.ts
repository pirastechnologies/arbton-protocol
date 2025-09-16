import { Address } from '@ton/core';
import { makeClient, getDeployer, readCompiled, sendDeploy } from './deploy-utils';

async function main() {
  const client = await makeClient();
  const { opened, secretKey } = await getDeployer(client);

  const { code, data } = readCompiled('build/LiquidityLocker.compiled.json');
  const lockerAddr = Address.computeAddress(0, { code, data });

  console.log('Deploying LiquidityLocker to:', lockerAddr.toString());
  await sendDeploy(client, opened, secretKey, lockerAddr, { code, data }, '0.35');
  console.log('✅ LiquidityLocker deployed at:', lockerAddr.toString());
}
main().catch(console.error);
