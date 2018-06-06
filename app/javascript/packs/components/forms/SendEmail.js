import React from "react";
import _ from "lodash";

import { withRouter } from 'react-router'
import axios from "axios/index";

class SendEmail extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      from_address: '',
      to_addresses: '',
      cc_addresses: '',
      bcc_addresses: '',
      subject: '',
      body: ''
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleInputChange = this.handleInputChange.bind(this);
    this.renderErrors = this.renderErrors.bind(this);
  }

  handleInputChange = (event) => {
    const target = event.target;
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.name;

    this.setState({
      [name]: value
    });
  };

  handleSubmit = (event) => {
    // Convert state to required state for submission.
    const request = {
      from_attributes: {email: this.state.from_address},
      subject: this.state.subject,
      body: this.state.body,
    };

    if (this.state.to_addresses.length > 0) {
      const to_addresses = _.split(this.state.to_addresses, " ");
      request['to_attributes'] = to_addresses.map((add) => ({email: add}))
    }
    if (this.state.cc_addresses.length > 0) {
      const cc_addresses = _.split(this.state.cc_addresses, " ");
      request['cc_attributes'] = cc_addresses.map((add) => ({email: add}))
    }
    if (this.state.bcc_addresses.length > 0) {
      const bcc_addresses = _.split(this.state.bcc_addresses, " ");
      request['bcc_attributes'] = bcc_addresses.map((add) => ({email: add}))
    }

    axios.post("/api/v1/emails", request)
      .then((response) => {
        this.props.history.push('/');
      })
      .catch((err) => {
        this.setState({
          errors: err.response.data.errors
        });
      })
  };

  renderErrors() {
    if (this.state.errors) {
      return <div>
        {this.state.errors.map((err, idx) => (<div className="alert alert-danger" key={idx}>
          {err}
        </div>
        ))}
      </div>
    }
  }

  render() {
    return <form>
      <div className="form-group row">
        <label htmlFor="from-address" className="col-sm-2 col-form-label">From Address</label>
        <div className="col-sm-10">
          <input name="from_address" className='form-control' placeholder="From email" onChange={this.handleInputChange} value={this.state.from_address}/>
        </div>
      </div>
      <div className="form-group row">
        <label htmlFor="subject" className="col-sm-2 col-form-label">To Addresses</label>
        <div className="col-sm-10">
          <input name="to_addresses" className='form-control' placeholder="To emails" onChange={this.handleInputChange} value={this.state.to_addresses}/>
          <small className="form-text text-muted">A space separated list of email addresses</small>
        </div>
      </div>
      <div className="form-group row">
        <label htmlFor="subject" className="col-sm-2 col-form-label">CC Addresses</label>
        <div className="col-sm-10">
          <input name="cc_addresses" className='form-control' placeholder="CC emails" onChange={this.handleInputChange} value={this.state.cc_addresses}/>
          <small className="form-text text-muted">A space separated list of email addresses</small>
        </div>
      </div>
      <div className="form-group row">
        <label htmlFor="subject" className="col-sm-2 col-form-label">BCC Addresses</label>
        <div className="col-sm-10">
          <input name="bcc_addresses" className='form-control' placeholder="BCC emails" onChange={this.handleInputChange} value={this.state.bcc_addresses}/>
          <small className="form-text text-muted">A space separated list of email addresses</small>
        </div>
      </div>
      <div className="form-group row">
        <label htmlFor="subject" className="col-sm-2 col-form-label">Subject</label>
        <div className="col-sm-10">
          <input name="subject" className='form-control' placeholder="Subject" onChange={this.handleInputChange} value={this.state.subject}/>
        </div>
      </div>
      <div className="form-group row">
        <label htmlFor="body" className="col-sm-2 col-form-label">Body</label>
        <div className="col-sm-10">
          <textarea name="body" className="form-control" placeholder="Body" onChange={this.handleInputChange} value={this.state.body}/>
        </div>
      </div>
      {this.renderErrors()}
      <button type="button" onClick={this.handleSubmit} className="btn btn-primary">Send</button>
    </form>
  }
}

export default withRouter(SendEmail)
