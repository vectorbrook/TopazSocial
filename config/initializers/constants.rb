APP_URL = "http://topazsocial.com/"

ROLES = %w[admin approver moderator customer prospect sales_engineer sales_manager support_engineer support_manager]
DEFAULT_ROLES = %w[user employee]
ALL_ROLES = ROLES + DEFAULT_ROLES

ACTIONS = %w[read create modify delete enable disable approve disapprove lock unlock]
RESOURCES = %w[user forum_category forum topic post account site contact service_case]

ACCOUNT_TYPES = %w[atype1 atype2]

SERVICECASE_STATUSES = ["New", "Open" ,"Closed" ,"Pending", "Information Requested" ,"Assigned"]
SERVICECASE_PRIORITIES = (1..10).to_a

TWITTER_CONSUMER_KEY = 'uJbq8NjQaRbFJC0FzxenKA'
TWITTER_CONSUMER_SECRET = 'hCc88DpKUZvkDnE4pkWh2tH0Zkg08NHfItw2OKXnhs'

FB_APP_ID = '362913200735'
FB_API_KEY = 'd06c8cab278c42ef4572c9be1349901a'
FB_APP_SECRET = '95c1952b223c9339f0f7386bd188eaa7'

