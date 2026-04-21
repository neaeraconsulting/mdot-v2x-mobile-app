# ISS SCMS Package Wrapper

The ISS SCMS package serves as a wrapper library around the IOS and Android SDK’s provided by ISS for performing signing and verification on a mobile device. This library was kept separate from the main code body of the V2X-Mobile-App application because splitting it off provides a clean way to implement the android and IOS specific functionality. Additionally, this component of the V2X-Mobile-App application is nicely encapsulated and it may be valuable to release as its own library in the future for others to use.


## Android
For additional information about the ISS Android SDK Please see documentation here:
- [Java Package](https://central.sonatype.com/artifact/com.iss-scms.dm.android/localdevicesecurityapi) 
- [Docs](https://www.javadoc.io/doc/com.iss-scms.dm.android/localdevicesecurityapi/latest/index.html)


## IOS
- [Swift Package](https://github.com/ghsiss/TrafficAuthV2XClient)
- [Docs]( https://ghsiss.github.io/TrafficAuthV2XClient/documentation/trafficauth_v2xclient_ios/)
