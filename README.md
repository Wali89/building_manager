# Building Manager API

Building Manager API is a Ruby on Rails application that provides a RESTful API for managing buildings and clients. It allows users to create, read, update, and delete buildings associated with clients, as well as manage custom fields for buildings.

## Features

- CRUD operations for buildings and clients
- Custom fields for buildings with different data types (number, freeform, enum)
- Pagination for building listings
- Client-specific building management

## Requirements

- Ruby (version 3.1)
- Rails (version 7.1)
- PostgreSQL 

## Installation

1. Clone the repository:
<pre>
git clone https://github.com/wali89/building_manager.git
cd building_manager
</pre>

2. Install dependencies:
<pre>
bundle install
</pre>

3. Set up the database:
<pre>
rails db:create db:migrate db:seed
</pre>

4. Start the server:
<pre>
rails server
</pre>

## API Endpoints

### Buildings

- `GET /api/v1/buildings` - List all buildings (paginated)
- `GET /api/v1/clients/:client_id/buildings` - List buildings for a specific client
- `GET /api/v1/clients/:client_id/buildings/:id` - Get details of a specific building
- `POST /api/v1/clients/:client_id/buildings` - Create a new building
- `PUT /api/v1/clients/:client_id/buildings/:id` - Update a building

### Clients

- `GET /api/v1/clients` - List all clients
- `GET /api/v1/clients/:id` - Get details of a specific client
- `POST /api/v1/clients` - Create a new client

## Models

- `Building`: Represents a building with an address and associated client
- `Client`: Represents a client
- `CustomField`: Defines custom fields for buildings belongs to a client (e.g., number of floors, year built)
- `CustomFieldValue`: Stores the values of custom fields for each building

## Custom Fields

The application supports three types of custom fields:
- `number`: Numeric values
- `freeform`: Free text input
- `enum`: Predefined options

Custom fields are defined per client.

## Error Handling

The API returns appropriate status codes and error messages for invalid requests or server errors.

## Pagination

Building listings are paginated by default. You can specify `page` and `per_page` parameters in your requests.