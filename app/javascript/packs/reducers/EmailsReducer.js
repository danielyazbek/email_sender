
export default function reducer(state={
    emails: [],
    fetching: false,
    fetched: false,
    error: null,
  }, action) {

  switch (action.type) {
    case "FETCH_EMAILS": {
      return {...state, fetching: true}
    }
    case "FETCH_EMAILS_REJECTED": {
      return {...state, fetching: false, error: action.payload}
    }
    case "FETCH_EMAILS_FULFILLED": {
      return {
        ...state,
        fetching: false,
        fetched: true,
        emails: action.payload,
      }
    }
  }
  return state
};
