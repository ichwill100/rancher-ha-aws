"""
configure-rancher-github-auth.py 

This script enables Github Authentication on a Rancher cluster

Usage:
    configure-rancher-github-auth.py (--rancherurl=<u>) (--orgid=<o>) (--clientid=<c>) (--clientsecret=<s>) (--pingtimeout=<p>) (--adminlist=<a>)

Options:
    -u --rancherurl=<u>      URL of the rancher control server/ELB
    -o --orgid=<o>           Github entity's external ID
    -i --clientid=<i>        Github OAuth application Client ID
    -s --clientsecret=<s>    Github OAuth Client Secret
    -p --pingtimeout=<p>     Time to wait for Rancher URL to become available
    -a --adminlist=<a>       Comma separated list of github user IDs to be made Admins
    -h --help                display this help text
"""

import requests, json, sys, time, backoff, traceback
from docopt import docopt

def ping_rancher(rancher_url):
    try:
        resp = requests.get(
            "{}/ping".format(rancher_url),
            timeout=pingtimeout
        )
        if resp and resp.status_code == 200:
            return True
    except:
        print '-'*60
        print "Exception while pinging Rancher\n"
        traceback.print_exc()
        print '-'*60
        

def check_if_auth_enabled(rancher_url):
    try:
        resp = requests.get(
            "{}/v1/token".format(rancher_url),
            timeout=30
        ).json()
        if resp['data'][0]['enabled']:
            print "Access Control is enabled and using type: {}".format(
                resp['data'][0]['authProvider']
            )
            sys.exit(1)
        return False
    except:
        print "Exception while checking if Auth is enabled\n"
        traceback.print_exc()
        raise

def auth_payload(orgid, clientid, clientsecret):
    payload_dict = {
        "type":"config",
        "provider":"githubconfig",
        "enabled":True,
        "accessMode":"restricted",
        "allowedIdentities":[
            {
                "externalIdType":"github_org", 
                "externalId": orgid
            }
        ],
        "githubconfig": {
            "clientId": clientid,
            "clientSecret": clientsecret
        },
    }
    return json.dumps(payload_dict)

def get_github_user_id(username):
    try:
        id = requests.get(
            "https://api.github.com/users/{}".format(
                username
            )
        ).json()['id']
        return id
    except:
        print "Exception while checking ID of github user\n"
        traceback.print_exc()
        raise

def admin_payload(adminid):
    payload_dict = {
        "kind": "admin",
        "externalId": adminid,
        "externalIdType": "github_user"
    }
    return json.dumps(payload_dict)

def set_account_as_admin(rancher_url, api_path, headers, adminid):
    try:
        payload = admin_payload(adminid)
        post_request_to_rancher(
            rancher_url,
            api_path,
            payload,
            headers
        )
    except:
        print "Exception while setting Account as admin\n"
        traceback.print_exc()
        raise
    

def post_request_to_rancher(rancher_url, api_path, payload, headers):
    try:
        resp = requests.post(
            "{}{}".format(rancher_url, api_path),
            data = payload,
            headers = headers,
            timeout=30
        )
    except:
        print "Exception while posting request to rancher\n"
        traceback.print_exc()
        raise

def wait_on_rancher(rancher_url):
    i = 0
    while i <= 10:
        if ping_rancher(rancher_url):
            return True
        else:
            print "Unsuccessful ping, retrying"
            time.sleep(2)
            i += 1
    else:
        print "Unable to contact Rancher"
        raise Exception

if __name__ == '__main__':
    arguments = docopt(__doc__)
    rancherurl = arguments["--rancherurl"]
    github_orgid = arguments["--orgid"]
    github_clientid = arguments["--clientid"]
    github_clientsecret = arguments["--clientsecret"]
    pingtimeout = int(arguments["--pingtimeout"])
    adminlist = arguments["--adminlist"]
    headers = {
        'content-type':"application/json",
        'accept':"application/json"
    }

    try:
        if wait_on_rancher(rancherurl):
            if check_if_auth_enabled(rancherurl) == False:
                for a in adminlist.split(','):
                    github_id = get_github_user_id(a)
                    admin = set_account_as_admin(
                        rancherurl,
                        "/v1/accounts",
                        headers,
                        github_id
                    )

                enable_auth = post_request_to_rancher(
                    rancherurl,
                    "/v1-auth/config",
                    auth_payload(
                        github_orgid,
                        github_clientid,
                        github_clientsecret
                    ),
                    headers
                )
                print "Authentication successfully enabled"
    except:
        print '-'*60
        print "Exception: \n"
        traceback.print_exc()
        print '-'*60


