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
