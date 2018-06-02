import React from 'react'
import _ from "lodash";
import moment from "moment";

export default class TableRow extends React.Component {
  render() {
    const email = this.props.email;

    let rowClass = "";
    switch (email.state) {
      case "successful" : {
        rowClass = "table-success";
        break;
      }
      case "pending": {
        rowClass = "table-warning";
        break;
      }
      case "failed": {
        rowClass = "table-danger";
        break;
      }
    }

    return <tr className={rowClass}>
      <th scope="row">{email.id}</th>
      <td>{_.capitalize(email.state)}</td>
      <td>{_.truncate(email.subject, {length: 30})}</td>
      <td>{email.from_address}</td>
      <td>{email.to_addresses.length}</td>
      <td>{email.cc_addresses.length}</td>
      <td>{email.bcc_addresses.length}</td>
      <td>{_.truncate(email.body, {length: 30})}</td>
      <td>{moment(email.updated_at).format('DD/MM/YYYY HH:mm:ss')}</td>
    </tr>
  }
}
