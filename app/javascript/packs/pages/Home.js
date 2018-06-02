import React from 'react'
import { connect } from 'react-redux'

import {fetchEmails} from "../actions/EmailsActions";
import TableRow from "../components/email/TableRow";

@connect((store) => {
  return {
    emails: store.emails
  };
})
export default class Home extends React.Component {
  componentWillMount() {
    this.props.dispatch(fetchEmails())
  }

  render() {
    const {emails} = this.props.emails;

    if (!emails.length) {
      return <p>
        No emails have been sent by this service.
      </p>
    }
    const mappedEmails = emails.map(email => <TableRow key={email.id} email={email}/>);

    return <table className="table table-hover table-sm">
      <thead>
        <tr>
          <th scope="col">ID</th>
          <th scope="col">State</th>
          <th scope="col">Subject</th>
          <th scope="col">From</th>
          <th scope="col">To</th>
          <th scope="col">CC</th>
          <th scope="col">BCC</th>
          <th scope="col">Body</th>
          <th scope="col">Date/Time</th>
        </tr>
      </thead>
      <tbody>
        {mappedEmails}
      </tbody>
    </table>;
  }
}
