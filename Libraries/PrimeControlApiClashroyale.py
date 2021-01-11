import requests
import json
import csv
from requests import get
from datetime import datetime as dt
import codecs

def get_datetime_now():
    return str(dt.now())

def get_external_ip():
    return get('https://api.ipify.org').text

def create_name_api():
    now = dt.now()
    nameApi = str(now)
    nameApi = nameApi.replace('-','')
    nameApi = nameApi.replace(':','')
    nameApi = nameApi.replace('.','')
    nameApi = nameApi.replace(' ','')
    nameApi = 'KeyTest(' + nameApi + ')'
    return nameApi

def clash_royale_api(apiToken, endpoints):
    api_url = 'https://api.clashroyale.com/v1'
    req=requests.get(
        api_url + endpoints,
        headers={
            "Accept":"application/json", "authorization":"Bearer %s" % apiToken
        })
    return json.dumps(req.json(), indent = 2)

def search_clan_by_name(apiToken, ClanName, refTag, countryCode):
    ClanName = ClanName.replace(' ','%20')
    ClanName = ClanName.replace("'",'')
    refTag = refTag.replace("'",'')
    countryCode = countryCode.replace("'",'')
    endpoints = '/clans?name=' + ClanName
    data = json.loads(clash_royale_api(apiToken, endpoints))['items']
    for i in data:
        if (i['tag'][0:len(refTag)] == refTag):
            if (i['location']['countryCode'] == countryCode.upper()):
                return i
    return None

def get_info_members(apiToken, ClanName, refTag, countryCode):
    infoClan = search_clan_by_name(apiToken, ClanName, refTag, countryCode)
    clanTag = (infoClan['tag']).replace('#','%23')
    endpoints = '/clans/' + clanTag + '/members'
    data = json.loads(clash_royale_api(apiToken, endpoints))
    return data['items']

def get_list_tag_name_members(apiToken, ClanName, refTag, countryCode):
    info_members = get_info_members(apiToken, ClanName, refTag, countryCode)
    listMenbers = []
    for i in info_members:
        listMenbers.append([i['tag'],i['name']])
    return listMenbers

def write_info_members_to_csv(apiToken, ClanName, refTag, countryCode, csvPathFile):
    info_members = get_info_members(apiToken, ClanName, refTag, countryCode)
    f = open(csvPathFile, 'w', encoding='utf-8')
    with f:
        fnames = ['Nome', 'Level', 'Trofeus', 'Papel']
        writer = csv.DictWriter(f, fieldnames=fnames)
        writer.writeheader()
        for i in info_members:
            Nome = i['name']
            Level = i['expLevel']
            Trofeus = i['trophies']
            Papel = i['role']
            writer.writerow({'Nome' : Nome, 'Level': Level, 'Trofeus' : Trofeus, 'Papel': Papel})

def get_full_path_csv_file(CURDIR,PathFileName):
    CURDIR = CURDIR.replace("\\",'/')
    return CURDIR + '/' + PathFileName

def data_register(pathFile, strData, tipo='k', mode='a'):
    file = codecs.open(pathFile, mode, "utf-8")
    if tipo == 'k':
        strSeparator = '\n    ==>'
        file.write(strSeparator+strData)
    else:
        strSeparator = '...............................................................................'
        file.write('\n'+strSeparator+'\n'+strData)
    file.close()
