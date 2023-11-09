//a 32-bit spinlock library for COS kernel
//author:Totan

//note: trap flag is also restored at spinlock_give so modify trap flag outside the spinlock

#ifndef SPINLOCK_H
#define SPINLOCK_H

#include<stdint.h>
#include<stdbool.h>
#include<stdatomic.h>

#include<general/cosdef.h>

typedef struct{
	uint16_t lock;
	uint16_t prev_state;
}spinlock_t;

void volatile spinlock_take(spinlock_t* lock_ptr){
	asm inline volatile("pushf\ncli\nspinlock_take:\nlock bts [%1],0\njc spinlock_take\npop %0\n":"=r"(lock_ptr->prev_state):"r"(&lock_ptr->lock):"cc");
}

bool volatile spinlock_weak_take(spinlock_t* lock_ptr){
	bool ret = false;
	asm inline volatile("pushf\ncli\nlock bts [%1],0\nsetnc %0\n":"=r"(ret):"r"(&lock_ptr->lock):"cc");
	if(common(ret)){
		asm inline volatile("pop %0\n":"=r"(lock_ptr->prev_state):);
	}else{
		asm inline volatile("popf\n"::"cc")
	}
	return ret;
}

void volatile spinlock_give(spinlock_t* lock_ptr){
	asm inline volatile("push %0\nlock btr [%1],0\npopf\n"::"r"(lock_ptr->prev_state),"r"(&lock_ptr->lock):"cc");
}

void volatile spinlock_init(spinlock_t* lock_ptr){
	lock_ptr->prev_state = 0;
	lock_ptr->lock = 0;
	atomic_thread_fence(memory_order_seq_cst);
}

#endif