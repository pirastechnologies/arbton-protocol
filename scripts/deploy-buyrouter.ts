import { Address } from '@ton/core';
import { makeClient, getDeployer, readCompiled, sendDeploy } from './deploy-utils';

async function main() {
  const client = await makeClient();
  const { opened, secretKey } = await getDeployer(client);

  const { code, data } = readCompiled('build/BuyRouter.compiled.json');
  const routerAddr = Address.computeAddress(0, { code, data });

  console.log('Deploying BuyRouter to:', routerAddr.toString());
  await sendDeploy(client, opened, secretKey, routerAddr, { code, data }, '0.35');
  console.log('✅ BuyRouter deployed at:', routerAddr.toString());
}
main().catch(console.error);
