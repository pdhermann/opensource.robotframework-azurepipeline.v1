import string
import urllib
from unidecode import unidecode

class UrlKeywords(object):
    """This Library has methods to encode and decode an url."""
    ROBOT_LIBRARY_SCOPE = 'Global'

    def encode_url(self, url):
      '''
      Encodes the given url that would (probably) contain characters outside the ASCII set into a valid ASCII format
      `Returns: string`
      '''
      return urllib.parse.quote_plus(url)


    def decode_url(self, url):
      '''
      Decodes the given url back into their single-character equivalent. It does the reverse of what the encode method
      above
      `Returns: string`
      '''
      return urllib.parse.unquote_plus(url)

    def decode_string(self, input):
      '''
      Decodes the given input
      above
      `Returns: string`
      '''
      return unidecode(input)
  
    def encode_string(self, input: string, encoding: string = 'utf-8'):
      '''
      Encodes the given input
      above
      `Returns: string`
      '''
      return input.encode(encoding)
