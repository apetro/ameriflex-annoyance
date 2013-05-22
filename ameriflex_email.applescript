(* Simple script for automating creation of an email I have to send far more
often than I should.

USAGE
=====
Run the script and follow the onscreen prompts.

LICENSE (MIT LICENSE)
=====================
Copyright (c) 2013 Dave Lesser

Permission is hereby granted, free of charge, to any person obtaining a
copy ofthis software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THESOFTWARE.*)

-- start of mainline of script
-- globals
global windowTitle
set windowTitle to "Send AmeriFlex Email"

-- get user input
set documentID to getDocumentID()
set documentDate to getDocumentDate()
set emailAttachment to getAttachment()

-- create and send email
set email to createEmail(documentID, documentDate, emailAttachment)
sendEmail(email)
-- end of mainline of script

-- get the document ID from user input
to getDocumentID()
	getTextFromDialog("Please enter the Document Tracking Number: ")
end getDocumentID

-- get the document date from user input
to getDocumentDate()
	getTextFromDialog("Please enter document date")
end getDocumentDate

-- returns user input from a dialog box with the supplied text 
to getTextFromDialog(dialogText)
	text returned of (display dialog dialogText default answer "" with title windowTitle)
end getTextFromDialog

-- get attachment from user input
to getAttachment()
	choose file with prompt "Please select the document to attach:"
end getAttachment

-- display provided message to user with only "OK" button
to displayMessage(msg)
	display dialog msg buttons {"OK"} default button 1 with title windowTitle
end displayMessage

-- displays message indicating if email was sent based on boolean provided
to displayEmailSentMessage(bool)
	if bool then
		set msg to "Message Sent!"
	else
		set msg to "Oops, something went wrong. Message not sent."
	end if
	
	displayMessage(msg)
end displayEmailSentMessage

-- creates and returns new email
to createEmail(documentID, documentDate, emailAttachment)
	set emailAddress to "claims@flex125.com"
	set emailSubject to "AmeriFlex Substantiation Request " & documentID
	set emailContent to createEmailContent(documentID, documentDate)
	
	emailFactory(emailAddress, emailSubject, emailContent, emailAttachment)
end createEmail

-- instantiate and return new email instance with the provided parameters 
to emailFactory(emailAddress, emailSubject, emailContent, emailAttachment)
	tell application "Mail"
		# create the message
		set email to make new outgoing message with properties {subject:emailSubject, content:emailContent}
		
		# set receipient
		tell email
			make new to recipient with properties {address:emailAddress}
			make new attachment with properties {file name:emailAttachment} at after the last paragraph
		end tell
	end tell
	
	email
end emailFactory

-- sends email and displays message to user.
-- returns value of Mail's send method
to sendEmail(email)
	tell application "Mail"
		set rtn to send email
	end tell
	
	displayEmailSentMessage(rtn)
	rtn
end sendEmail

-- generate the full content for the email
to createEmailContent(documentID, documentDate)
	createEmailGreeting() & createEmailBody(documentID, documentDate) & createSignature()
end createEmailContent

-- create the email greeting, including two trailing newlines
to createEmailGreeting()
	"Dear Sir or Madam,
	
"
end createEmailGreeting

-- create the email body, with no leading or trailing newlines
to createEmailBody(documentID, documentDate)
	set body to "This email is in response to a AmeriFlex Substantiation Request, document tracking number "
	set body to body & documentID
	set body to body & ", I received, dated "
	set body to body & documentDate
	set body to body & ". Please find attached a PDF that shows the explanation of benefits.

I believe this should satisfy your request for substantiation, but please let me know if you require anything additional."
end createEmailBody

-- create email signature, including two leading newlines
to createSignature()
	"
	
Best regards,
Sheldon

Sheldon Cooper
scooper@caltech.edu
626.555.1212"
end createSignature
