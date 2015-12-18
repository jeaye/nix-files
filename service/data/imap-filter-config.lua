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
  local mails = account.INBOX:select_all()
  move_mailing_lists(account, mails)

  -- Ignore some senders
  delete_mail_from(account, mails, "foo@spam.com")

  -- Don't be bothered each time imap-filter runs
  delete_mail_if_subject_contains(accounts mails, "bin/imapfilter")

  -- Get all mail from trash
  local trash = account['Trash']:select_all()
  move_mailing_lists(account, trash)

  -- Get all mail from spam
  local spam = account['Spam']:select_all()
  move_mailing_lists(account, spam)
end

function move_mailing_lists(account, mails)
  -- ISOCPP mailing lists
  move_if_subject_contains(account, mails, "[std-proposals]", "ML/ISOCPP")
  move_if_subject_contains(account, mails, "[std-discussion]", "ML/ISOCPP")

  -- NixOS
  move_if_subject_contains(account, mails, "[Nix-dev]", "ML/NixOS")

  -- Slackware
  move_if_subject_contains(account, mails, "[slackware-announce]", "ML/Slackware")
  move_if_subject_contains(account, mails, "[slackware-security]", "ML/Slackware")
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

function get_imap_password(file)
  local home = os.getenv("HOME")
  local file = home .. "/" .. file
  local str = io.open(file):read()
  return str;
end

main()
