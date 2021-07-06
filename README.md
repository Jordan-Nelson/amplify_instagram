# amplify_instagram

This is an instagram clone built with AWS amplify and Flutter.

_Note:_ The main purpose of the project is to demonstrate how to build a social media app with amplify, not imitating the exact UI and UX of Instagram.

## Features

- Auth / User Profile
  - [x] Basic Auth flow
  - [x] Add user entities to Dynamo via post sign up lambda trigger
  - [ ] Social authentication (facebook, etc.)
  - [ ] Editable profile (bio, etc)
  - [ ] Editable profile picture
  - [ ] Followers
- New Feed
  - [x] Create posts w/ images
  - [ ] Create posts w/ video
  - [x] Basic news feed layout
  - [x] Comment on posts
  - [x] Live updates of top comments (streaming)
  - [ ] View all comments (pagination)
  - [ ] News feed w/ only posts from those that you follow
  - [ ] Sync only posts in your news feed (sync expressions)
  - [ ] Stories
- Search
  - [ ] Search for users
