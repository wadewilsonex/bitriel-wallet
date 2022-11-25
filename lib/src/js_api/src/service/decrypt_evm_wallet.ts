import {ethers} from "ethers";
import { resolve } from "../../webpack.config";
import phone from "./phone.json";

async function decrypt(json: any, password: string) {

    console.log("decrypt");
    console.log("json", typeof json);
    
    const data =  new Promise( async (resolve, reject) => {
        console.log("JSON.stringify(phone)", JSON.stringify(json));
        console.log("typeof JSON.stringify(phone)", typeof JSON.stringify(json));
        console.log("password", password);
        console.log("typeof password", typeof password);
        const wallet = await ethers.Wallet.fromEncryptedJson(JSON.stringify(json), password);
        console.log("wallet", wallet.mnemonic.phrase);
        resolve(wallet.mnemonic.phrase); // return wallet.mnemonic.phrase;
    
    });

    console.log("returing data ", data);

    return data;

}

async function decryptZin(password: string) {

    console.log("decryptZin");

    return new Promise( async function (resolve, reject) {
        
        console.log("JSON.stringify(phone)", JSON.stringify(phone));
        console.log("typeof JSON.stringify(phone)", typeof JSON.stringify(phone));
        console.log("password", password);
        console.log("typeof password", typeof password);
        const wallet = await ethers.Wallet.fromEncryptedJson(JSON.stringify(phone), password);
        console.log("wallet", wallet.mnemonic.phrase);
        resolve(wallet.mnemonic.phrase); // return wallet.mnemonic.phrase;
    
    });

}

export default { 
    decrypt,
    decryptZin
}