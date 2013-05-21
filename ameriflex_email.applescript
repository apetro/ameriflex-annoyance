# mainline of script
on run argv
	# parse command line arguments
	set reqNumber to item 1 of argv
	set reqDate to item 2 of argv
	
	# create, but don't send, email
	createEmail(reqNumber, reqDate)
	
	# friendly message to display in terminal
	"Email successfully created"
end run

# creates and returns new email
to createEmail(reqNumber, reqDate)
	set emailAddress to "claims@flex125.com"
	set emailSubject to "AmeriFlex Substantiation Request " & reqNumber
	set emailContent to createEmailContent(reqNumber, reqDate)
	
	emailFactory(emailAddress, emailSubject, emailContent)
end createEmail

# instantiate and return new email instance with the provided parameters 
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

# generate the full content for the email
to createEmailContent(reqNumber, reqDate)
	createEmailGreeting() & createEmailBody(reqNumber, reqDate) & createSignature()
	
end createEmailContent

# create the email greeting, including two trailing newlines
to createEmailGreeting()
	"Dear Sir or Madam,
	
"
end createEmailGreeting

# create the email body, with no leading or trailing newlines
to createEmailBody(reqNumber, reqDate)
	set body to "This email is in response to a AmeriFlex Substantiation Request, document tracking number "
	set body to body & reqNumber
	set body to body & ", I received, dated "
	set body to body & reqDate
	set body to body & ". Please find attached a PDF that shows the explanation of benefits.

I believe this should satisfy your request for substantiation, but please let me know if you require anything additional."
end createEmailBody

# create email signature, including two leading newlines
to createSignature()
	"
	
Best regards,
Sheldon

Sheldon Cooper
scooper@caltech.edu
626.555.1212"
end createSignature
