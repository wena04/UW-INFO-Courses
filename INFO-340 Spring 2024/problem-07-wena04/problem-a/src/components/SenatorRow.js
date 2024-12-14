import React from "react"; //import React library

//example senator data objects:
// { id: 'C000127', name: 'Maria Cantwell', state: 'WA', party: 'Democrat', phone: '202-224-3441', twitter: 'SenatorCantwell' },
// { id: 'M001111', name: 'Patty Murray', state: 'WA', party: 'Democrat', phone: '202-224-2621', twitter: 'PattyMurray' }

/* Your code goes here */
export function SenatorRow({ senatorData }) {
  let senator = senatorData;
  let senatorName = senator.name;
  let senatorStateParty = senator.party.slice(0, 1) + " - " + senator.state;
  let senatorPhoneNum = senator.phone;
  let senatorPhoneNumForHref = "tel:" + senator.phone;
  let senatorTwitter = "https://twitter.com/" + senator.twitter;
  let senatorTwitterHandle = "@" + senator.twitter;
  return (
    <tr>
      <td>{senatorName}</td>
      <td>{senatorStateParty}</td>
      <td>
        <a href={senatorPhoneNumForHref}>{senatorPhoneNum}</a>
      </td>
      <td>
        <a href={senatorTwitter}>{senatorTwitterHandle}</a>
      </td>
    </tr>
  );
}
