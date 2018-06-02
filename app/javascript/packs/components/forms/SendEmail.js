import React from "react";

const SendEmail = () => (
  <form>
    <div class="form-group row">
      <label for="from-address" class="col-sm-2 col-form-label">From Address</label>
      <div class="col-sm-10">
        <input type="email" name="from-address" class="form-control" placeholder="From Email Address" />
      </div>
    </div>
    <div class="form-group row">
      <label for="to-addresses" class="col-sm-2 col-form-label">To Addresses</label>
      <div class="col-sm-10">
        <input type="" name="to-addresses"class class="form-control" placeholder="To Email Addresses"/>
      </div>
    </div>
    <div class="form-group row">
      <label for="cc-addresses" class="col-sm-2 col-form-label">CC Addresses</label>
      <div class="col-sm-10">
        <input type="" name="cc-addresses" class="form-control" placeholder="CC Email Addresses"/>
      </div>
    </div>
    <div class="form-group row">
      <label for="bcc-addresses" class="col-sm-2 col-form-label">BCC Addresses</label>
      <div class="col-sm-10">
        <input type="" name="bcc-addresses" class="form-control" placeholder="BCC Email Addresses"/>
      </div>
    </div>
    <div class="form-group row">
      <label for="subject" class="col-sm-2 col-form-label">Subject</label>
      <div class="col-sm-10">
        <input type="" name="subject" class="form-control" placeholder="Subject"/>
      </div>
    </div>
    <div class="form-group row">
      <label for="body" class="col-sm-2 col-form-label">Body</label>
      <div class="col-sm-10">
        <textarea name="body" class="form-control" placeholder="Body"/>
      </div>
    </div>
    <button type="submit" class="btn btn-primary">Send</button>
  </form>
);

export default SendEmail
