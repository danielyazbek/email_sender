import { combineReducers } from 'redux'
import { reducer as formReducer } from 'redux-form'

import EmailsReducer from "./EmailsReducer";

export default combineReducers({
  emails: EmailsReducer,
  form: formReducer
});
