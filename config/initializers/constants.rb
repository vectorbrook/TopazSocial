#ROLES = %w[admin approver moderator customer prospect sales_engineer sales_manager support_agent support_manager social_media_manager community_manager]
#DEFAULT_ROLES = %w[user employee]

#ALL_ROLES = ROLES + DEFAULT_ROLES

EMPLOYEE_CATEGORY = "employee"
PROSPECT_CATEGORY = "prospect"
CUSTOMER_CATEGORY = "customer"

USER_CATEGORIES = [EMPLOYEE_CATEGORY, PROSPECT_CATEGORY, CUSTOMER_CATEGORY]

DEFAULT_CATEGORY = EMPLOYEE_CATEGORY

EMPLOYEE_ROLES = %w[admin service_manager service_agent community_manager social_media_manager sales_manager sales_engineer employee]
PROSPECT_ROLES = %w[prospect]
CUSTOMER_ROLES = %w[contact primary]

EMPLOYEE_ROLES_DEFAULT = "employee"
PROSPECT_ROLES_DEFAULT = "prospect"
CUSTOMER_ROLES_DEFAULT = "contact"

ALL_ROLES = EMPLOYEE_ROLES + PROSPECT_ROLES + CUSTOMER_ROLES

ACTIONS = %w[read create modify delete enable disable approve disapprove lock unlock]
RESOURCES = %w[user forum_category forum forum_topic forum_post customer_account customer_site customer_contact service_case sales_lead sales_opportunity]

ACCOUNT_TYPES = %w[atype1 atype2]

SERVICECASE_STATUSES = ["New", "Open" ,"Closed" ,"Pending", "Information Requested" ,"Assigned"]
SERVICECASE_PRIORITIES = (1..10).to_a

TWITTER_CONSUMER_KEY = 'TWITTER_CONSUMER_KEY '
TWITTER_CONSUMER_SECRET = 'TWITTER_CONSUMER_SECRET '

POSITIVE = 1
NEGATIVE = -1
NEUTRAL = 0
