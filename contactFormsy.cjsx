React = require 'react'
Formsy = require 'formsy-react'
http = require 'superagent'
{Input, Textarea} = require 'formsy-react-components'

module.exports = React.createClass
  getInitialState: ->
    canSubmit: false

  enableButton: ->
    @setState canSubmit: true
    return

  disableButton: ->
    @setState canSubmit: false
    return

  submit: (data, resetForm, invalidateForm) ->
    data.siteId = 'cape'
    unless data.url
      delete data.url
    console.log data
    http.post('/api/contact').send(data).type('json').end (res) ->
      {badRequest, body} = res
      if res.badRequest
        alert(body?.message)
      else
        console.log body
        if body?.status is 'sent'
          alert("Sent email to #{body.email}. \n Confirmation: #{body._id}")
          resetForm()
        else
          alert('The message failed to send.')
    return

  render: ->
    {canSubmit} = @state
    <Formsy.Form onValidSubmit={@submit} onValid={@enableButton} onInvalid={@disableButton}>
      <div>Hello!</div>
      <Input name="name" validations={maxLength: 75, minLength: 3} validationError="Is this really your name?" label="Your Name" required/>
      <Input name="email" validations="isEmail" validationError="This is not a valid email" label="Your Email" required/>
      <Input name="phone" validations={maxLength: 20} validationError="That doesn't look right." label="Your Phone"/>
      <Input layout="elementOnly" name="url" className="hidden" validations="isEmptyString" validationError="This field is only for spam bots." label="Leave this URL field empty!" />
      <Input
        name="subject" label="Subject"
        validations={maxLength: 140} validationErrors={maxLength: 'Whooa there, keep the subject under 140 characters please.'}
        validationError="Your subject line is no good."
      />
      <Textarea name="body" label="Message" validations={maxLength: 25000} validationError="Too much text for us to handle..." required />
      <button type="submit" disabled={!canSubmit}>Submit</button>
    </Formsy.Form>
