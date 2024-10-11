# SSO Scheme

### Identity Provider
The service which ties some identity token per say to the resource owner, can also be the authentication server and vise versa


### Service Provider/ Resource Server
The server which has the service that wants to be accessed, either by the resource owner or some other service acting on behalf of the resource owner.


### Authentication Server
Application that knows the resource owner, where the resource owner already has an account. They simply login and this then authorizes interactions on behalf of them with the scope given.
Authorization code helps to bootstrap PKI with client, which the client then receives an access token which acts as the credentials to do what the client needs to do on behalf of the resource owner with the scope tied to the token.


### Resource Owner
The user (human being) that is being represented by the identity provide. The whole scheme is made so that you can delegate what can be done with your resources.

### Client
Application that wants to perform actions or access data on behalf of the resource owner. There's a client ID which helps to uniquely identify the client, and a secret which allows for secure information sharing (public key infrastructure PKI)



# OpenID Connect OIDC

Oauth is only used an authorization server, it manages keys but does not tie the key to any singular ID for a resource owner. 

OpenID is similar to giving a badge instead of a key, this having the ID and permissions.

With Oauth client knows it can access these resources and what to do with it, but does not tie it back back to a user meanwhile OpenID allows for it to be tied back.
[Video explaining it](https://youtu.be/t18YB3xDfXI?si=myaM5iJQGOta3WzZ)


### Bugs

Make sure docker network has authelia as an aliases for this to work, don't let it be implicitly defined.