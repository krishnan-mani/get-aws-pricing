#!/usr/bin/env python

# Preliminary (throwaway) script that pulls down pricing information

import json
import requests
from pprint import pprint

PRICING_PUBLISHED_FROM_REGION = 'us-east-1'
DEFAULT_PRICING_API_VERSION = '/v1.0'

def get_offers_index_url(version = DEFAULT_PRICING_API_VERSION):
	return "https://pricing." + PRICING_PUBLISHED_FROM_REGION + ".amazonaws.com/offers" + version + "/aws/index.json"


def construct_offer_url(url_suffix):
	return "https://pricing." + PRICING_PUBLISHED_FROM_REGION + ".amazonaws.com" + url_suffix


def obtain_offer_urls(offers):
	offer_urls = {}
	all_services_offered = offers.keys()

	for key in all_services_offered:
		currentVersionUrl = offers[key]["currentVersionUrl"]
		full_url = construct_offer_url(currentVersionUrl)
		offer_urls[key] = full_url

	return offer_urls


all_offer_urls = {}
offers_index_url = get_offers_index_url(DEFAULT_PRICING_API_VERSION)
offers_index_file = requests.get(offers_index_url).text
offers_index_data = json.loads(offers_index_file)
publication_date = offers_index_data["publicationDate"]

all_offers = offers_index_data["offers"]
offer_urls = obtain_offer_urls(all_offers)


def fetch_offer_index(url):
	return requests.get(url).text


all_offers = {}
services = offer_urls.keys()
for service in services:
	service_offer_index_url = offer_urls[service]
	print service, service_offer_index_url
	# service_offer = json.loads(fetch_offer_index(service_offer_index_url))
	# all_offers[service] = service_offer
