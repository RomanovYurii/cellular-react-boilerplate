import React from 'react';
import ReactDOM from 'react-dom';
import './index.scss';
import RootNavigator from './navigation/RootNavigator';
import { Provider } from 'react-redux';
import { PersistGate } from 'redux-persist/integration/react';
import { store, persistor } from './redux/store';

const Root = () => (
	<Provider store={store}>
		<PersistGate persistor={persistor}>
			<RootNavigator />
		</PersistGate>
	</Provider>
);

ReactDOM.render(<Root />, document.getElementById('root'));
