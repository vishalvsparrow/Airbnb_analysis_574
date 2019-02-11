import requests
import time
import random
from make_json import make_json
import pandas as pd
import json

dat = pd.read_csv('vishal_select_clean.csv')
mlist_id = list()

# https://www.airbnb.com/api/v2/reviews?key=d306zoyjsyarp7ifhu67rjxn52tv0t20&currency=USD&locale=en&listing_id=6914622&role=guest&_limit=15&_order=language_country

# mlist_id = [3075044, 1436513, 849408, 5434353, 13251243, 6400432, 5498472,
#             1704090, 1187188, 903598, 9903, 14444280, 12379725, 7225376, 5660081, 13968660, 1426711, 5510597, 12849985,
#             12320063, 4823089, 7871576, 5904992, 5222368, 66288, 11313921, 6629929, 12074204, 4160585, 13391024, 195515]

mlist_id = dat['id'].values.tolist()
# mlist_id = list(dat['id'].values) # If the dangling L creates a problem, use this

print(len(mlist_id))
print(mlist_id)

raw_list = list()
final_list = list()
empty_index = list()

index = 0
count = 1
for mID in mlist_id:
    index = index + 1
    url = "https://www.airbnb.com/api/v2/reviews?key=d306zoyjsyarp7ifhu67rjxn52tv0t20&currency=USD&locale=en" \
          "&listing_id=%s&role=guest&_limit=100&_order=language_country" % mID
    resp = requests.get(url)
    print('------------>', count)
    print(resp.json())
    each_resp = resp.json()
    raw_list.append(each_resp)
    if not each_resp["reviews"]:
        empty_index.append(mID)
        continue
    else:
        final_list.append(make_json(each_resp, each_resp["reviews"][0]["listing_id"]))
        count = count + 1

    if not count == len(mlist_id):
        time.sleep(random.uniform(2, 7))

        # if count == 7:
        #    break

print(final_list)
print(empty_index)

# with open('final_comments_1.json', 'w') as test_file:
#    json.dump(final_list, test_file, indent=4, separators=(',', ': '))

# with open('skipped_rows.txt', 'w') as skipped:
#    skipped.writelines("Empty reviews IDs\n\n")
#    skipped.writelines(list("%s\n" % item for item in empty_index))

# with open('raw_each_resp', 'w') as test_file_1:
#    json.dump(raw_list, test_file_1, indent=4, separators=(',', ': '))
#
