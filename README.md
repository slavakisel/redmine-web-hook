WebHook plugin sends POST request to the web hook url whenever any of the following events take place:

* Issue has been updated
* Issue comment has been added/edited/deleted
* Attachment added/deleted to an issue

Request contains brief details about event. E.g.:

```
{
 'issueid': 12345,
 'userid': 12345,
 'datetime': '2014-13-12 12:13:14'
}
```

Web hook url should be specified in the plugin settings section:

![Plugin Settings](http://i6.5cm.ru/i/587S.png)!
