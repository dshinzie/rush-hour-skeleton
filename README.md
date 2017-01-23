## Rush Hour

This project uses Ruby, Sinatra, and ActiveRecord to build a web traffic tracking and analysis tool.

RushHour is an application that aggregates and analyzes visitor data from another website. A RushHour customer/client will embed JavaScript in their website that will gather and send their visitor data to our site. It is important to note that we will not be creating this JavaScript. Instead we will simulate the process of gathering and receiving data, which we will call a payload. Our job is to build the application that can accept the submission of these payloads, analyze the data submitted, and display it through a HTML interface.

This is similar to how a tool like [Google Analytics](https://www.google.com/analytics/) might work. When you visit a page that has Google Analytics installed, you don't necessarily see any indication of that on the page, there's just a script that runs in the background and sends your information to Google. We're building the part of the app that receives that information (in the Google Analytics example, this would be on a Google server somewhere), and then displays the information to 'users', which in this case means businesses that pay for the analysis we provide. **In the past we have heard that students aren't clear on what they're building until part way through this project, so please ask questions if this is at all unclear.**

We will use pre built payloads to simulate the gathered data from a customer/client's website. They will look like this:

```
payload = '{
  "url":"http://jumpstartlab.com/blog",
  "requestedAt":"2013-02-16 21:38:28 -0700",
  "respondedIn":37,
  "referredBy":"http://jumpstartlab.com",
  "requestType":"GET",
  "eventName": "socialLogin",
  "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
  "resolutionWidth":"1920",
  "resolutionHeight":"1280",
  "ip":"63.29.38.211"
}'
```

The payloads are in a hash-like format called JSON. You will need to learn how to interact with JSON in ruby. Find the Ruby JSON docs [here](http://www.ruby-doc.org/stdlib-2.0/libdoc/json/rdoc/JSON.html).

RushHour will simulate sending these requests using a cURL command. This is a command we can run in our terminal that sends an HTTP request. You can checkout the details of the cURL command by running `curl --manual` in your terminal.
