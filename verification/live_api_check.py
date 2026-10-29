"""Creates only an isolated QA account; deletes that account in finally.
No customer records, admin endpoints or account credentials are used.
"""
import json, os, secrets, urllib.request, urllib.error, datetime
BASE=os.environ.get('API_BASE_URL','http://56.228.53.36:8000')
results=[];token=None

def call(method,path,data=None,auth=True,raw=None,content_type=None):
 headers={'Accept':'application/json'}
 if auth and token: headers['Authorization']='Bearer '+token
 body=raw
 if data is not None: body=json.dumps(data).encode();headers['Content-Type']='application/json'
 if content_type: headers['Content-Type']=content_type
 req=urllib.request.Request(BASE+path,data=body,headers=headers,method=method)
 try:
  with urllib.request.urlopen(req,timeout=25) as response: code=response.status;payload=response.read();kind=response.headers.get('Content-Type','')
 except urllib.error.HTTPError as e: code=e.code;payload=e.read();kind=e.headers.get('Content-Type','')
 results.append({'method':method,'path':path,'status':code})
 if code>=400: raise RuntimeError(f'{method} {path}: {code} '+payload.decode()[:400])
 return json.loads(payload) if 'json' in kind and payload else payload

email='qa-integration-'+secrets.token_hex(6)+'@example.com';password=secrets.token_urlsafe(24)
try:
 call('GET','/health/live',auth=False);call('GET','/health/ready',auth=False)
 config=call('GET','/v1/app-config',auth=False)
 pending=call('POST','/v1/auth/register',{'name':'Integration QA (temporary)','email':email,'password':password},auth=False)
 otp=pending.get('otp')
 if not otp: raise RuntimeError('Server did not expose local OTP; email verification required. No authenticated tests run.')
 call('POST','/v1/auth/verify-otp',{'email':email,'otp':otp},auth=False)
 session=call('POST','/v1/auth/login',{'email':email,'password':password},auth=False);token=session['access_token']
 call('GET','/v1/auth/me')
 session=call('POST','/v1/auth/refresh',{'refresh_token':session['refresh_token']},auth=False);token=session['access_token']
 call('POST','/v1/businesses',{'business_name':'Integration QA Studio','currency':'USD'})
 call('GET','/v1/business');call('PATCH','/v1/business',{'tagline':'Temporary verification'})
 # A valid generated 1x1 PNG, used only for this test account.
 import base64
 png=base64.b64decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aX1sAAAAASUVORK5CYII=')
 boundary='qa'+secrets.token_hex(8)
 multipart=(f'--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="logo.png"\r\nContent-Type: image/png\r\n\r\n'.encode()+png+f'\r\n--{boundary}--\r\n'.encode())
 call('PUT','/v1/business/logo',raw=multipart,content_type='multipart/form-data; boundary='+boundary)
 image=call('GET','/v1/business/logo');assert image[:8]==b'\x89PNG\r\n\x1a\n'
 item=call('POST','/v1/library',{'kind':'service','name':'QA service','unit_price':'25.00','unit_cost':'5.00'})
 ident=item['id'];call('GET',f'/v1/library/{ident}');call('PATCH',f'/v1/library/{ident}',{'name':'QA updated service'});call('GET','/v1/library')
 draft={'lines':[{'kind':'service','description':'QA service','unit_price':'25.00','unit_cost':'5.00'}], 'tax_rate_percent':'5','deposit':{'mode':'percent','value':'30'}}
 preview=call('POST','/v1/quotes/preview',draft)
 quote=call('POST','/v1/quotes',{**draft,'client':{'name':'QA test client'}});qid=quote['id']
 assert quote['totals']==preview['totals']
 call('GET','/v1/quotes');call('GET',f'/v1/quotes/{qid}');call('PATCH',f'/v1/quotes/{qid}',{'notes':'QA updated note'})
 duplicate=call('POST',f'/v1/quotes/{qid}/duplicate');call('DELETE',f"/v1/quotes/{duplicate['id']}")
 for suffix in ['pdf','cost-sheet/pdf']:
  pdf=call('GET',f'/v1/quotes/{qid}/{suffix}');assert pdf.startswith(b'%PDF-')
 call('PATCH',f'/v1/quotes/{qid}/status',{'status':'accepted'})
 invoice=call('POST',f'/v1/quotes/{qid}/invoice',{});iid=invoice['id']
 call('GET','/v1/invoices');call('GET',f'/v1/invoices/{iid}')
 assert call('GET',f'/v1/invoices/{iid}/pdf').startswith(b'%PDF-')
 call('PATCH',f'/v1/invoices/{iid}/status',{'status':'paid'})
 call('GET','/v1/dashboard')
 call('DELETE',f'/v1/library/{ident}');call('DELETE','/v1/business/logo')
 call('POST','/v1/auth/logout')
 token=call('POST','/v1/auth/login',{'email':email,'password':password},auth=False)['access_token']
 results.append({'check':'PDF magic bytes, logo signature, preview vs saved totals','result':'passed'})
except Exception as error:
 results.append({'check':'test interruption','error':str(error)})
finally:
 if token:
  try:call('DELETE','/v1/auth/me')
  except Exception as error:results.append({'check':'cleanup','error':str(error)})
 report={'checked_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'results':results,'legal_links_configured':bool(config.get('terms_url') and config.get('privacy_url'))}
 open('verification/live_api_results.json','w').write(json.dumps(report,indent=2))
 print(json.dumps(report,indent=2))
