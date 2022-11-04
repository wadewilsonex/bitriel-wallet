import {ethers} from "ethers";
import phone from "./phone.json";

async function decrypt(json, password: string) {
    console.log("Hello decrypt");
    console.log("json", json);
    console.log("password", password);
    console.log("JSON.stringify(phone)", JSON.stringify(phone));
    console.log("JSON.stringify(json)", JSON.stringify(json));
    const wallet = await ethers.Wallet.fromEncryptedJson(JSON.stringify(json), password);
    console.log("wallet", wallet.mnemonic.phrase);
    return wallet.mnemonic.phrase;
}

export default {
    decrypt
}