import { Address } from '@ton/core';
import { makeClient, getDeployer, readCompiled, sendDeploy } from './deploy-utils';

async function main() {
  const client = await makeClient();
  const { opened, secretKey } = await getDeployer(client);

  const { code, data } = readCompiled('build/LiquidityManager.compiled.json');
  const managerAddr = Address.computeAddress(0, { code, data });

  console.log('Deploying LiquidityManager to:', managerAddr.toString());
  await sendDeploy(client, opened, secretKey, managerAddr, { code, data }, '0.35');
  console.log('✅ LiquidityManager deployed at:', managerAddr.toString());
}
main().catch(console.error);
