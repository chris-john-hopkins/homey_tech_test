# Homey Technical Task - Project Conversation History

## Hosted link
https://homey-tech-test-5aa7e068ec62.herokuapp.com/projects

## Assumptions & Questions

Since the task brief is minimal, I made the following assumptions and raised questions that I would typically ask my colleagues to clarify requirements. Where possible, I provided reasonable expected answers based on my experience.

### Questions I Would Ask

1. **How should project status changes be tracked?**  
   - Expected answer: When a status change occurs, it should be recorded as a timeline event along with the new status.

2. **What are the valid project statuses?**  
   - Expected answer: Common statuses might be `draft`, `in_progress`, `completed`, but this should be confirmed.

3. **Who can change project statuses?**  
   - Expected answer: Any authenticated user.

4. **Should project documentation support rich text?**  
   - Expected answer: Yes, since detailed project documentation is difficult with plain text, rich text is necessary.

5. **How should the project status changes be displayed?**  
   - Expected answer: A chronological feed showing status changes.

6. **Should the status changes be managed with a state machine?**  
   - Expected answer: Yes, as maintaining a history of project status changes suggests the need for a state machine dependency. I assume this dependency already exists somewhere in the app. I have used statesman gem since that's what I'm used to but I would follow the pattern set out in any existing repo ordinarily. 

7. **Should updates/comments be handled with Turbo Streams and WebSockets?**  
   - Expected answer: Yes, as per the Homey technical tools document, this aligns well with the feature set and simplifies real-time updates.

8. **Is the project management feature behind authentication?**  
   - Expected answer: Yes, all project-related actions should be restricted to authenticated users.
9. **Should Comments be implemented as a polymorphic association**
    - Yes since, making them polymorphic allows for greater flexibility and reuse. This avoids the need to create separate comment models for each entity while keeping the system extensible.

---

## Implementation Decisions

### **1. Data Model**

- **Project (`projects` table)**
  - `title: string`
  - `status: string` (enum: `pending`, `in_progress`, `completed`)
  - `timestamps`
  - Rich text enabled for documentation

- **User (`users` table)**
  - Handled by Devise authentication

- **Project Transition (`project_transitions` table)**
  - `previous_status: string`
  - `new_status: string`
  - `user_id: references`
  - `project_id: references`
  - `timestamps`

- **Comment (`comments` table)**
  - `body: rich_text`
  - `commentable_type: string` (polymorphic association)
  - `commentable_id: integer`
  - `user_id: references`
  - `timestamps`


### **2. Routes**

- `POST /projects/:id/project_transitions` - Change project status
- `GET /projects` - Show all projects
- `GET /projects/:id` - Show a project

### **3. Future Enhancements**

- Pagination for comments and projects
- Make use of active storage integration with trix editor to allow files to be attached to projects/comments
- better styling
- Currently I am broadcasting comment updates from the model which I don't like. I would move this to a background job and call it from somewhere else. Either the controller or some kind of service class perhaps? 
- Move error html to it's own shared partial so that it can be reused

## Running Locally

```sh
brew install postgres
bundle install
rails db:create db:seed
bin/dev
```