import React from 'react'

import TableRow from "../components/email/TableRow";
import axios from "axios/index";

export default class Home extends React.Component {

  constructor(props) {
    super(props);
    this.getEmails = this.getEmails.bind(this);
    this.state = {emails: []}
  }

  getEmails() {
    axios.get("/api/v1/emails")
      .then((response) => {
        this.setState({emails: response.data})
      })
      .catch((err) => {

      })
  }

  componentWillMount() {
    this.getEmails();
  }

  componentDidMount() {
    this.intervalId = setInterval(this.getEmails, 3000);
  }

  componentWillUnmount() {
    clearInterval(this.intervalId);
  }

  render() {
    const {emails} = this.state;

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
