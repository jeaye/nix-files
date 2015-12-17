function main()
  local account = IMAP
  {
    server = 'localhost',
    username = 'jeaye',
    password = get_imap_password(".secret/imap-filter-pass"),
    ssl = 'tls1',
  }

  -- Make sure the account is configured properly
  account.INBOX:check_status()

  -- Get all mail from INBOX
  mails = account.INBOX:select_all()

  -- Move mailing lists from INBOX to correct folders
  move_mailing_lists(account, mails)

  -- Delete some trash
  delete_mail_from(account, mails, "foo@spam.com");

  -- Get all mail from trash
  mails = account['Trash']:select_all()

  -- Move mailing lists from trash to correct folders
  move_mailing_lists(account, mails)

  -- Get all mail from spam
  mails = account['Spam']:select_all()

  -- Move mailing lists from spam to correct folders
  move_mailing_lists(account, mails)
end

function move_mailing_lists(account, mails)
  -- ISOCPP mailing lists
  move_if_subject_contains(account, mails, "[std-proposals]", "ML/ISOCPP")
  move_if_subject_contains(account, mails, "[std-discussion]", "ML/ISOCPP")
end

function move_if_subject_contains(account, mails, subject, mailbox)
  filtered = mails:contain_subject(subject)
  filtered:move_messages(account[mailbox]);
end

function move_if_to_contains(account, mails, to, mailbox)
  filtered = mails:contain_to(to)
  filtered:move_messages(account[mailbox]);
end

function move_if_from_contains(account, mails, from, mailbox)
  filtered = mails:contain_from(from)
  filtered:move_messages(account[mailbox]);
end

function delete_mail_from(account, mails, from)
  filtered = mails:contain_from(from)
  filtered:delete_messages()
end

function delete_mail_if_subject_contains(account, mails, subject)
  filtered = mails:contain_subject(subject)
  filtered:delete_messages()
end

-- Utility function to get IMAP password from file
function get_imap_password(file)
  local home = os.getenv("HOME")
  local file = home .. "/" .. file
  local str = io.open(file):read()
  return str;
end

main()
