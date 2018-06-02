import { combineReducers } from 'redux'

import EmailsReducer from "./EmailsReducer";

export default combineReducers({
  emails: EmailsReducer
});
