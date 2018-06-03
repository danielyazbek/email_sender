import React from "react";
import { Field, FieldArray, reduxForm } from 'redux-form'
import { submit } from 'redux-form'
import { connect } from 'react-redux'
import _ from "lodash";
import FaTrash from 'react-icons/lib/fa/trash'
import FaPlus from 'react-icons/lib/fa/plus'

import { withRouter } from 'react-router'

import { submitEmail } from "../../actions/EmailsActions";

const initialData = {
  to_addresses: [''],
  cc_addresses: [''],
  bcc_addresses: [''],
};

const renderField = ({ input, label, type, meta: { touched, error } }) => {
  if (_.isArray(error)) {
    error = _.join(error, ', ');
  }
  let errorClass = (touched && error) ? "is-invalid" : "";

  return <div>
      <input {...input} type={type} placeholder={label} className={`form-control ${errorClass}`}/>
      <div className="invalid-feedback">
        {error}
      </div>
    </div>
};

const renderTextAreaField = ({ input, label, type, meta: { touched, error } }) => {
  if (_.isArray(error)) {
    error = _.join(error, ', ');
  }
  let errorClass = (touched && error) ? "is-invalid" : "";
  return <div>
    <textarea {...input} type={type} placeholder={label} className={`form-control ${errorClass}`}/>
    {touched && error && <div className="invalid-feedback">
      {error}
    </div>}
  </div>
};

const renderEmailFields = ({ fields, label, meta: { error } }) => {
  return <div className="form-group row">
    <label className="col-sm-2 col-form-label">
      {label} Addresses
    </label>
    <div className="col-sm-10">
      {fields.map((email, index) => (
        <div className="row" key={index}>
          <div className="form-group col-sm-10">
            <Field
              name={email}
              type="text"
              component={renderField}
              label={`${label} email`}
            />
          </div>
          <div className="col-sm-1">
            <button
              type="button"
              className="btn btn-danger"
              title={`Remove ${label}`}
              onClick={() => fields.remove(index)}
              disabled={index === 0}>
              <FaTrash/>
            </button>
          </div>
          <div className="col-sm-1">
            <button type="button" onClick={() => fields.push()} className="btn btn-primary">
              <FaPlus/>
            </button>
          </div>
        </div>
      ))}
    </div>
  </div>
};

@connect((store) => {
  return {
    store: store
  };
})
class SendEmail extends React.Component {

  componentWillMount() {
    this.props.initialize(initialData);
  }

  submitForm() {
    this.props.dispatch(submit('emailForm'));
  }

  render() {
    if (this.props.store.emails.submitted) {
      this.props.history.push('/');
      return null;
    }

    const {handleSubmit, pristine, submitting} = this.props;
    return <form onSubmit={handleSubmit}>
      <div className="form-group row">
        <label htmlFor="from-address" className="col-sm-2 col-form-label">From Address</label>
        <div className="col-sm-10">
          <Field name="from_address" component={renderField} type="text" className="form-control" label="From email"/>
        </div>
      </div>
      <FieldArray name="to_addresses" component={renderEmailFields} label="To" />
      <FieldArray name="cc_addresses" component={renderEmailFields} label="CC" />
      <FieldArray name="bcc_addresses" component={renderEmailFields} label="BCC" />
      <div className="form-group row">
        <label htmlFor="subject" className="col-sm-2 col-form-label">Subject</label>
        <div className="col-sm-10">
          <Field name="subject" component={renderField} type="text" className="form-control" label="Subject"/>
        </div>
      </div>
      <div className="form-group row">
        <label htmlFor="body" className="col-sm-2 col-form-label">Body</label>
        <div className="col-sm-10">
          <Field name="body" component={renderTextAreaField} className="form-control" label="Body"/>
        </div>
      </div>
      <button type="button" onClick={this.submitForm.bind(this)} disabled={pristine || submitting} className="btn btn-primary">Send</button>
    </form>
  }
}

export default withRouter(reduxForm({
  form: 'emailForm',
  onSubmit: submitEmail
})(SendEmail))
