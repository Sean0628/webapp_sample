# README
## Setup Instructions

1. **Clone the Repository**:

    ```sh
    git clone git@github.com:Sean0628/webapp_sample.git
    ```

    ```sh
    cd webapp_sample
    ```

2. **Start the Services**:

    ```sh
    docker-compose up -d
    ```

3. **Database Setup**:

    Create the database:

    ```sh
    docker-compose run --rm web rails db:create
    ```

    Run the migrations:

    ```sh
    docker-compose run --rm web rails db:migrate
    ```

    Seed the database:

    ```sh
    docker-compose run --rm web rails db:seed
    ```

4. **Wait for Data Sync**:

    Wait for 10 minutes at most to get the issuer data loaded from the external system.

5. **Access the Application**:

    Open your browser and navigate to [http://localhost:3000/issuers/](http://localhost:3000/issuers/).

---

## Assignment

### 1. View: View a list of all issuers with an option to view more information and edit.

- 1.1. You can view a list of all issuers on the index page: [http://localhost:3000/issuers/](http://localhost:3000/issuers/).
- 1.2. You can view more information about an issuer on the show page: [http://localhost:3000/issuers/:id](http://localhost:3000/issuers/:id). You can navigate to the show page from the index page by clicking on the `Show` link.
- 1.3. You can edit an issuer on the edit page: [http://localhost:3000/issuers/:id/edit](http://localhost:3000/issuers/:id/edit). You can navigate to the edit page from the show page by clicking on the `Edit` link.

### 2. Edit and approve: Edit fields and be able to submit an edit request.

- 2.1. You can edit an issuer on the edit page: [http://localhost:3000/issuers/:id/edit](http://localhost:3000/issuers/:id/edit), and submit an edit request by clicking on the `Submit` button.

### 3. Pending Reviews: Should be able to see any pending submissions for field updates.

- 3.1. You can view a list of pending edit requests on the index page: [http://localhost:3000/edit_requests/](http://localhost:3000/edit_requests/).

### 4. Approved information: Fields should only be updated if an edit request has been approved by the external system. Remember, people who approve edit requests only have access to the external database.

- 4.1. You can approve/reject an edit request by running the following command:

    ```sh
    # <EditRequest.id> is the id of the edit request you want to approve/reject.
    # You can find the id on the edit request show page (http://localhost:3000/edit_requests/:id). (RequestID column)
    # <new_status> is approved or rejected
    $ docker-compose run --rm web rails runner ./scripts/update_external_edit_request_status.rb <EditRequest.id> <new_status>
    ```

### 5. Sync:

- 5.1. The application syncs data with the external system every 10 minutes. You can see the logs in the terminal by running:

    ```sh
    $ docker-compose logs -f sidekiq
    ```

### 6. Unit tests/Black Box Integration Tests:

- 6.1. You can run the tests by executing the following command:

    ```sh
    $ docker-compose run --rm web rspec
    ```

## External Data Synchronization

Every 10 minutes, the backend data will be loaded from the external database. For this project, both the external and internal services can use MySQL databases on the same machine or even different sets of tables within the same database.

- Tables with the `external_` prefix are designated for the external service.
- Tables without the `external_` prefix are used by our internal application.

This setup ensures that the application can seamlessly integrate and synchronize data between the internal system and the external service.
