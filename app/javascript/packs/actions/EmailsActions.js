import { SubmissionError } from 'redux-form'
import axios from "axios";

export function fetchEmails() {
  return function(dispatch) {
    dispatch({type: "FETCH_EMAILS"});
    axios.get("/api/v1/emails")
      .then((response) => {
        dispatch({type: "FETCH_EMAILS_FULFILLED", payload: response.data})
      })
      .catch((err) => {
        dispatch({type: "FETCH_EMAILS_REJECTED", payload: err})
      })
  }
}

export function submitEmail(values) {
    if (values.to_addresses[0] === '') {
      values = {...values, to_addresses: null}
    }
    if (values.cc_addresses[0] === '') {
      values = {...values, cc_addresses: null}
    }
    if (values.bcc_addresses[0] === '') {
      values = {...values, bcc_addresses: null}
    }
  return axios.post("/api/v1/emails", values)
      .then((response) => {
        // OK
      })
      .catch((err) => {
        console.log("error: ", err.response.data.errors);
        throw new SubmissionError(err.response.data.errors)
      })
}
