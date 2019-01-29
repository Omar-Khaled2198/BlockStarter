import web3 from "./web3";

import CampaignFactory from "./build/CampaignFactory.json";

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  "0x24a8FEb160b9C48c5E7ffCd752E2F14509dcf338"
);

export default instance;
