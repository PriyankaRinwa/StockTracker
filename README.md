# stocks_tracker

A robust stock price tracker app built with **Flutter** using **Provider** for state management. It connects to a deliberately unstable internal WebSocket feed and handles network drops, corrupted messages, and logically anomalous data while maintaining smooth UI performance.

---

## Setup Instructions

### Prerequisites

- Flutter SDK (https://flutter.dev/docs/get-started/install)
- Dart SDK (included with Flutter)
- Android Studio / VSCode
- A device or emulator

### Run the Mock WebSocket Server

The app depends on a local Dart server (`mock_server.dart`) that emits random, malformed, and anomalous stock data.

1. Save the provided server script as `mock_server.dart`.
2. Run the server:
   ```bash
   dart mock_server.dart
   
### The server listens at:

ws://127.0.0.1:8080/ws (for emulators)
ws://<your-ip>/ws (for physical device replace <your-ip> with system ip)

### Run the Flutter App

- Clone this repo or download the project
- Install dependencies:
  flutter pub get
- Launch the app:
  flutter run


## Architectural Decisions

### State Management: **Provider**

**Why Provider?**

- Simple yet powerful for reactive UI
- Works well with WebSocket streams
- Enables fine-grained rebuilds via Selector

#### Project Structure

- WebSocketService	Handles socket connection, reconnection, parsing
- StockProvider	Manages app state, filters anomalies, notifies UI
- UI Widgets	Displays stock data with rebuild optimization

#### Separation of Concerns

- WebSocketService manages network logic
- StockProvider tracks latest valid stock data and connection status
- UI uses Selector to only rebuild when a specific stock changes


## Anomaly Detection Heuristic

### Heuristic Rule

> A price drop greater than 90% from the previous valid price is considered anomalous and ignored.

### Implementation Details

- Each stock item stores its previousPrice
- If drop > 90%, marked it isAnomalous = true and keep the last valid price
- Display a caution icon and orange color for flagged stocks


### Trade-offs

- Real market crash               **Might falsely flag as anomaly**
- Gradual market correction       **Handled normally**
- Flash spike/dip                 **Ignored unless repeated**


##  Performance Optimization

### Techniques Used

 Optimization Goal                                 Strategy                                    
- Avoid full widget tree rebuilds        |  Selector` per stock item                  
- Only notify listeners on real change   |  Deep list comparison in StockProvider    
- Efficient scrolling                    |  ListView.builder with minimal UI widgets  
- Maintain smooth UI updates             |  Optional throttling for fast WebSocket data 

###  DevTools Verification

Use **Flutter DevTools** → **Performance Tab**:
1. Tap "Record"
2. Interact with the stock list
3. Take screenshot
4. Stop recording
5. Confirm green UI and raster threads


##  Test Scenarios

The app gracefully handles the following:

- Sudden WebSocket disconnects
- Malformed JSON (e.g., missing values)
- Anomalous price drops (e.g., GOOG dropping 95%)
- Automatic exponential reconnects (2s → 4s → … → max 30s)

No crashes, no freezes.


##  Credits

Mock server inspired by real-time trading systems. Built for demonstrating WebSocket handling, data validation, anomaly detection, and smooth UI performance in Flutter.

