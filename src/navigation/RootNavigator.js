import React from 'react';
import { Router } from '@reach/router';
import App from '../components/App';

const RootNavigator = () => {
	return (
		<Router>
			<App path="/" />
		</Router>
	);
};

export default RootNavigator;
