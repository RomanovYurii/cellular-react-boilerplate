import rootReducer from './rootReducer';
import { composeWithDevTools } from 'redux-devtools-extension';
import { applyMiddleware, createStore } from 'redux';
import thunk from 'redux-thunk';
import { logger } from 'redux-logger';
import { persistStore } from 'redux-persist';

const middleware = [thunk, logger];

export const store = createStore(
	rootReducer,
	composeWithDevTools(applyMiddleware(...middleware))
);

export const persistor = persistStore(store);
