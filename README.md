# NoGoofingOff
Example of a macOS Safari time-based content blocker

This is just sample code, and pretty hack-y.

It consists of three components:
1. The NoGoofingOff macOS app, that registers the following two extensions.
2. The NoGoofingOffBlocker Safari content blocker, that blocks most URLs during working hours.
3. The NoGoofingOffTimerSafariExt Safari app extension, that reloads the NoGoofingOffBlocker Safari content blocker periodically.

The arms race between browser vendors and malware has resulted in a very restricted extension model for WebKit.
Safari extensions can only just handle a request, and the OS manages their process lifecycle.
Therefore, no persistent timer threads or GCD queues will work in extensions.

So, NoGoofingOffTimerSafariExt injects a JavaScript timer in the loaded content to periodically send messages back to itself.
Upon receipt of these messages, NoGoofingOffTimerSafariExt requests that the NoGoofingOffBlocker be reloaded if the appropriate amount of time has elapsed.
At load/reload time, NoGoofingOffBlocker provides the content blocking rules appropriate for the current time.
