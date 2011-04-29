APP_URL = "http://topazsocial.com/"

ROLES = %w[admin approver moderator customer prospect sales_engineer sales_manager support_engineer support_manager]
DEFAULT_ROLES = %w[user employee]
ALL_ROLES = ROLES + DEFAULT_ROLES

ACTIONS = %w[read create modify delete enable disable approve disapprove lock unlock]
RESOURCES = %w[user forum_category forum topic post account site contact service_case]

ACCOUNT_TYPES = %w[atype1 atype2]

SERVICECASE_STATUSES = ["New", "Open" ,"Closed" ,"Pending", "Information Requested" ,"Assigned"]
SERVICECASE_PRIORITIES = (1..10).to_a

TWITTER_CONSUMER_KEY = 'TWITTER_CONSUMER_KEY '
TWITTER_CONSUMER_SECRET = 'TWITTER_CONSUMER_SECRET '

FB_APP_ID = 'FB_APP_ID '
FB_API_KEY = 'FB_API_KEY '
FB_APP_SECRET = 'FB_APP_SECRET '

