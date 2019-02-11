import json

with open('data1.json') as data1:
    d1 = json.load(data1)

with open('data1-1.json') as data4:
    d4 = json.load(data4)

# with open('data2.json') as data2:
#     d2 = json.load(data2)
# with open('data3.json') as data3:
#     d3 = json.load(data3)

# print(type(d1))

# mcount = 0
# for mitem in d3["reviews"]:
#     mcount = mcount + 1
#     print(mcount)
#     print(mitem['comments'])
#     print("\n ------------------------------------------ \n")
# print(d3["reviews"])
# print(d2)

# reviews = {"list_id = 1":{"comments_total":25, "comments":{"comment_index = 1": "Great place", "comment_index = 2":
#  "Nice place"}}, "list_id = 2":{"comment_total":99, "comments":{"comment_index = 1": "Well I like Bronx, so....",
# "comment_index = 2": "Hurray", "comment_index = 3": "I like to travel, hell yeah!"}}}

# Global dictionary
# reviews = dict()


def make_json(json_object, list_id):
    temp_review = dict()
    if not list_id == json_object["reviews"][0]["listing_id"]:
        print("Listing ID mismatch. Error")
        return -1
    else:
        temp_review[list_id] = list_id

    temp_review[list_id] = {"total_comments": 0, "comments": {}}
    mcount = 0
    for mitem in json_object["reviews"]:
        mcount = mcount + 1
        temp_comment = mitem["comments"]
        temp_review[list_id]["comments"].update({mcount: temp_comment})

    temp_review[list_id]["total_comments"] = mcount

    return temp_review


# mdata1 = make_json(d1, d1["reviews"][0]["listing_id"])  # 2nd is list_id
# mdata2 = make_json(d4, d4["reviews"][0]["listing_id"])

# print(mdata1)
# print("\n -------------------------------------------------- \n")
# print(mdata2)

# mega_array = [mdata1, mdata2]
# for mega in mega_array:
#     print(mega)
#     print("\n---------------------------------\n")
