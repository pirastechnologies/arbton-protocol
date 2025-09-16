import 'dotenv/config';
import fs from 'fs';
import { mnemonicToPrivateKey } from '@ton/crypto';
import { Address, Cell, toNano } from '@ton/core';
import { TonClient, WalletContractV4, internal, SendMode } from '@ton/ton';

export async function makeClient() {
  return new TonClient({ endpoint: process.env.RPC_ENDPOINT! });
}

export async function getDeployer(client: TonClient) {
  const { publicKey, secretKey } = await mnemonicToPrivateKey(process.env.MNEMONIC!.split(' '));
  const wallet = WalletContractV4.create({ workchain: Number(process.env.WORKCHAIN ?? 0), publicKey });
  const opened = client.open(wallet);
  return { opened, secretKey };
}

export function readCompiled(path: string) {
  const j = JSON.parse(fs.readFileSync(path, 'utf8'));
  return {
    code: Cell.fromBase64(j.codeBoc),
    data: Cell.fromBase64(j.dataBoc),
  };
}

export async function sendDeploy(
  client: TonClient,
  openedWallet: any,
  secretKey: Buffer,
  to: Address,
  init: { code: Cell; data: Cell },
  valueTon = '0.35'
) {
  const seqno = await openedWallet.getSeqno();
  await openedWallet.sendTransfer({
    secretKey,
    seqno,
    messages: [
      internal({
        to,
        value: toNano(valueTon),
        init: { code: init.code, data: init.data },
        bounce: false,
      }),
    ],
    sendMode: SendMode.PAY_GAS_SEPARATELY,
  });
}
