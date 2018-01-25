//
//  main.cpp
//  KeyTracker
//
//  Created by Juan David Sierra on 1/22/18.
//  Copyright © 2018 Juan David Sierra. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    return 0;
}

class Vector {
    int capacity;
    int* data;
    
    void purge() {
        for(int i = 0; i < capacity; i++) {
            data[i] = 0;
        }
    }
    
public:
    
    Vector(int capacity) {
        data = new int[capacity];
    }
    
    void append(int value) {
        for(int i = 0; i < capacity; i++) {
            if(0 == data[i]) {
                data[i] = value;
                return;
            }
        }
        purge();
        append(value);
    }
    
    int indexOf(int value) {
        for (int i = 0; i < capacity; i++) {
            if (value == data[i]){
                return i;
            }
        }
        return -1;
    }
    
    void remove(int value) {
        for (int i = 0; i < capacity; i++) {
            if (value == data[i]) {
                data[i] = 0;
            }
        }
    }
    
    bool contains(int value) {
        for(int i = 0; i < capacity; i++) {
            if (value == data[i]) {
                return true;
            }
        }
        return false;
    }
    
    int totalCapacity() {
        return capacity;
    }
    
    int usedCapacity() {
        int count = 0;
        for (int i = 0; i < capacity; i++) {
            count += (data[i] != 0 ? 1 : 0);
        }
        return count;
    }
    
    int availableCapactiy() {
        int count = 0;
        for (int i = 0; i < capacity; i++) {
            count += (data[i] == 0 ? 1 : 0);
        }
        return count;
    }
};

class KeyTracker {
    int voiceCapacity;
    Vector* keys;
    
public:
    KeyTracker(int numKeys) : voiceCapacity(numKeys) {
        keys = new Vector(numKeys);
    }
    
    ~KeyTracker() {
        delete keys;
    }
    
    void keyOn(int key) {
        if (!keys->contains(key)) {
            keys->append(key);
        }
    }
    
    void keyOff(int key) {
        if (keys->contains(key)) {
            keys->remove(key);
        }
    }
};


