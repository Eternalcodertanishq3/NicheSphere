# Firestore Schema

Complete data model, collection structure, and security rules for NicheSphere.

---

## Collections

### `/users/{userId}`

```
{
  id:              string   // Firebase Auth UID
  name:            string
  username:        string   // unique, @handle
  email:           string
  avatarUrl:       string?
  avatarThumbUrl:  string?  // 100x100 thumbnail
  bio:             string?  // max 160 chars
  location:        string?
  website:         string?
  interests:       string[] // e.g. ["Gaming", "Tech", "Coffee"]
  eventsHosted:    number
  eventsAttended:  number
  followersCount:  number
  followingCount:  number
  badgeIds:        string[]
  isVerified:      boolean
  fcmToken:        string?  // for push notifications
  createdAt:       timestamp
  updatedAt:       timestamp
}
```

### `/events/{eventId}`

```
{
  id:                string
  title:             string
  description:       string
  category:          string  // "Gaming" | "Art" | "Tech" | ...
  tags:              string[]
  startAt:           timestamp
  endAt:             timestamp
  locationName:      string
  locationAddress:   string
  coordinates:       GeoPoint
  geohash:           string  // for geospatial queries
  imageUrl:          string
  imageThumbUrl:     string
  imageUrls:         string[] // gallery images
  attendeeCount:     number   // denormalized for performance
  maxAttendees:      number   // 0 = unlimited
  isFree:            boolean
  price:             number?
  currency:          string
  organizerId:       string   // userId
  organizerName:     string   // denormalized
  organizerAvatarUrl: string?
  communityId:       string?
  status:            "upcoming" | "live" | "ended" | "cancelled"
  visibility:        "public" | "friendsOnly" | "private"
  coHostIds:         string[]
  avgRating:         number
  reviewCount:       number
  isFeatured:        boolean
  liveStreamUrl:     string?
  createdAt:         timestamp
  updatedAt:         timestamp
}
```

### `/communities/{communityId}`

```
{
  id:            string
  name:          string
  description:   string
  category:      string
  imageUrl:      string
  bannerUrl:     string
  memberCount:   number   // denormalized
  creatorId:     string
  adminIds:      string[]
  isPrivate:     boolean
  tags:          string[]
  activityScore: number   // used for trending sort
  createdAt:     timestamp
}
```

### `/rsvps/{rsvpId}`

`rsvpId` format: `{userId}_{eventId}`

```
{
  id:        string
  userId:    string
  eventId:   string
  status:    "attending" | "waitlist" | "cancelled"
  createdAt: timestamp
}
```

### `/follows/{followId}`

`followId` format: `{followerId}_{followingId}`

```
{
  followerId:  string
  followingId: string
  createdAt:   timestamp
}
```

### `/communityMembers/{memberId}`

`memberId` format: `{communityId}_{userId}`

```
{
  communityId: string
  userId:      string
  role:        "member" | "admin" | "owner"
  joinedAt:    timestamp
}
```

### `/chatRooms/{roomId}`

```
{
  id:           string
  name:         string
  type:         "event" | "community" | "dm"
  eventId:      string?
  communityId:  string?
  memberIds:    string[]
  lastMessage:  string
  lastMessageAt: timestamp
  createdAt:    timestamp
}
```

### `/chatRooms/{roomId}/messages/{messageId}`

```
{
  id:             string
  chatRoomId:     string
  senderId:       string
  senderName:     string
  senderAvatarUrl: string?
  content:        string
  type:           "text" | "image" | "eventShare" | "system"
  imageUrl:       string?
  sentAt:         timestamp
  readBy:         string[]
  reactions:      Map<string, string>  // userId → emoji
}
```

### `/notifications/{notificationId}`

```
{
  id:         string
  userId:     string   // recipient
  type:       "rsvp" | "follow" | "reminder" | "comment" | "badge"
  title:      string
  body:       string
  data:       Map<string, dynamic>  // eventId, userId, etc.
  isRead:     boolean
  createdAt:  timestamp
}
```

### `/badges/{badgeId}`

```
{
  id:             string
  name:           string
  description:    string
  emoji:          string
  category:       "explorer" | "host" | "builder" | "trendsetter" | ...
  tier:           number  // 1 | 2 | 3
  requiredCount:  number
}
```

### `/userBadges/{userId}/earned/{badgeId}`

```
{
  badgeId:    string
  unlockedAt: timestamp
}
```

### `/reviews/{reviewId}`

```
{
  id:        string
  eventId:   string
  userId:    string
  rating:    number  // 1-5
  comment:   string?
  createdAt: timestamp
}
```

---

## Indexes

Create these composite indexes in `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "events",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status",    "order": "ASCENDING" },
        { "fieldPath": "startAt",   "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "events",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "category",  "order": "ASCENDING" },
        { "fieldPath": "startAt",   "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "events",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "geohash",   "order": "ASCENDING" },
        { "fieldPath": "startAt",   "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "events",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "isFeatured", "order": "ASCENDING" },
        { "fieldPath": "startAt",    "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "communities",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "activityScore", "order": "DESCENDING" },
        { "fieldPath": "createdAt",     "order": "DESCENDING" }
      ]
    }
  ]
}
```

---

## Security Rules

```javascript
// firestore.rules

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helpers
    function isAuth()          { return request.auth != null; }
    function isOwner(userId)   { return isAuth() && request.auth.uid == userId; }
    function isAdmin(communityId) {
      return isAuth() && exists(/databases/$(database)/documents/communityMembers/$(communityId + '_' + request.auth.uid))
             && get(/databases/$(database)/documents/communityMembers/$(communityId + '_' + request.auth.uid)).data.role in ['admin','owner'];
    }

    // Users
    match /users/{userId} {
      allow read:   if true;
      allow create: if isOwner(userId);
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
    }

    // Events
    match /events/{eventId} {
      allow read:   if resource.data.visibility == 'public' || isAuth();
      allow create: if isAuth();
      allow update: if isAuth() && (
        request.auth.uid == resource.data.organizerId ||
        request.auth.uid in resource.data.coHostIds
      );
      allow delete: if isAuth() && request.auth.uid == resource.data.organizerId;
    }

    // RSVPs
    match /rsvps/{rsvpId} {
      allow read:   if isAuth();
      allow write:  if isAuth() && request.auth.uid == resource.data.userId;
      allow create: if isAuth() && request.auth.uid == request.resource.data.userId;
    }

    // Communities
    match /communities/{communityId} {
      allow read:   if !resource.data.isPrivate || isAuth();
      allow create: if isAuth();
      allow update: if isAdmin(communityId);
      allow delete: if isAuth() && request.auth.uid == resource.data.creatorId;
    }

    // Community members
    match /communityMembers/{memberId} {
      allow read:   if isAuth();
      allow create: if isAuth() && request.auth.uid == request.resource.data.userId;
      allow delete: if isAuth() && (
        request.auth.uid == resource.data.userId ||
        isAdmin(resource.data.communityId)
      );
    }

    // Chat rooms
    match /chatRooms/{roomId} {
      allow read:   if isAuth() && request.auth.uid in resource.data.memberIds;
      allow create: if isAuth();
      allow update: if isAuth() && request.auth.uid in resource.data.memberIds;

      // Messages subcollection
      match /messages/{messageId} {
        allow read:   if isAuth() && request.auth.uid in get(/databases/$(database)/documents/chatRooms/$(roomId)).data.memberIds;
        allow create: if isAuth() && request.auth.uid == request.resource.data.senderId
                         && request.auth.uid in get(/databases/$(database)/documents/chatRooms/$(roomId)).data.memberIds;
        allow update: if isAuth() && request.auth.uid == resource.data.senderId;
      }
    }

    // Notifications
    match /notifications/{notificationId} {
      allow read:   if isOwner(resource.data.userId);
      allow update: if isOwner(resource.data.userId);
      allow create: if isAuth();
      allow delete: if isOwner(resource.data.userId);
    }

    // Badges (read-only for users)
    match /badges/{badgeId} {
      allow read: if true;
      allow write: if false; // admin SDK only
    }

    // User badges (earned)
    match /userBadges/{userId}/earned/{badgeId} {
      allow read: if true;
      allow write: if false; // Cloud Function only
    }

    // Follows
    match /follows/{followId} {
      allow read:   if true;
      allow create: if isAuth() && request.auth.uid == request.resource.data.followerId;
      allow delete: if isAuth() && request.auth.uid == resource.data.followerId;
    }

    // Reviews
    match /reviews/{reviewId} {
      allow read:   if true;
      allow create: if isAuth() && request.auth.uid == request.resource.data.userId;
      allow update: if isOwner(resource.data.userId);
      allow delete: if isOwner(resource.data.userId);
    }
  }
}
```

---

## Denormalization Strategy

To minimize reads, the following fields are denormalized (duplicated):

| Field | Stored in | Kept in sync by |
|---|---|---|
| `organizerName` | event doc | Cloud Function on user.name update |
| `attendeeCount` | event doc | Cloud Function on RSVP write |
| `memberCount` | community doc | Cloud Function on member join/leave |
| `followersCount` | user doc | Cloud Function on follow write |
| `followingCount` | user doc | Cloud Function on follow write |
| `eventsHosted` | user doc | Cloud Function on event create |
| `eventsAttended` | user doc | Cloud Function on RSVP attending |

Never update denormalized fields from client code. All counter updates go through Cloud Functions using `FieldValue.increment()` to avoid race conditions.
