import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import { persistStore, persistReducer } from 'redux-persist';
import storage from 'redux-persist/lib/storage';
import autoMergeLevel2 from 'redux-persist/lib/stateReconciler/autoMergeLevel2';

const INITIAL_STATE = {
    things: ""
};

const rootReducer = (state, action) => {
    console.log("incoming action:", action);
    switch(action.type) {
        case 'GET_THINGS_SUCCESS':
            return { ...state, things: action.data.polo }
        default:
            return state;
    }
}

const persistConfig = {
    key: 'root',
    storage: storage,
    stateReconciler: autoMergeLevel2 // see "Merge Process" section for details.
};
const pReducer = persistReducer(persistConfig, rootReducer);

export const store = createStore(pReducer, INITIAL_STATE, applyMiddleware(thunk));
export const persistor = persistStore(store);