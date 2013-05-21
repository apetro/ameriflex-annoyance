(* Simple script for automating creation of an email I have to send far more
often than I should.

USAGE
=====
$ osascript ameriflex_email.applescript document-id date

# Example
$ osascript ameriflex_email.applescript 123-45-678 "May 13, 2014"

LICENSE
=======
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

-- mainline of script
on run argv
	# parse command line arguments
	set reqNumber to item 1 of argv
	set reqDate to item 2 of argv
	
	# create, but don't send, email
	createEmail(reqNumber, reqDate)
	
	# friendly message to display in terminal
	"Email successfully created"
end run

-- creates and returns new email
to createEmail(reqNumber, reqDate)
	set emailAddress to "claims@flex125.com"
	set emailSubject to "AmeriFlex Substantiation Request " & reqNumber
	set emailContent to createEmailContent(reqNumber, reqDate)
	
	emailFactory(emailAddress, emailSubject, emailContent)
end createEmail

-- instantiate and return new email instance with the provided parameters 
to emailFactory(emailAddress, emailSubject, emailContent)
	tell application "Mail"
		# create the message
		set email to make new outgoing message with properties {subject:emailSubject, content:emailContent, visible:true}
		
		# set receipient
		tell email
			make new to recipient with properties {address:emailAddress}
		end tell
	end tell
	
	email
end emailFactory

-- generate the full content for the email
to createEmailContent(reqNumber, reqDate)
	createEmailGreeting() & createEmailBody(reqNumber, reqDate) & createSignature()
end createEmailContent

-- create the email greeting, including two trailing newlines
to createEmailGreeting()
	"Dear Sir or Madam,
	
"
end createEmailGreeting

-- create the email body, with no leading or trailing newlines
to createEmailBody(reqNumber, reqDate)
	set body to "This email is in response to a AmeriFlex Substantiation Request, document tracking number "
	set body to body & reqNumber
	set body to body & ", I received, dated "
	set body to body & reqDate
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
