
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	27013103          	ld	sp,624(sp) # 8000a270 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	749040ef          	jal	80004f5e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0001f797          	auipc	a5,0x1f
    80000034:	9d078793          	addi	a5,a5,-1584 # 8001ea00 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	27490913          	addi	s2,s2,628 # 8000a2c0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	16b050ef          	jal	800059c0 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	1f3050ef          	jal	80005a58 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	614050ef          	jal	80005692 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	1e650513          	addi	a0,a0,486 # 8000a2c0 <kmem>
    800000e2:	05f050ef          	jal	80005940 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	0001f517          	auipc	a0,0x1f
    800000ee:	91650513          	addi	a0,a0,-1770 # 8001ea00 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	1b848493          	addi	s1,s1,440 # 8000a2c0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	0af050ef          	jal	800059c0 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	1a450513          	addi	a0,a0,420 # 8000a2c0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	133050ef          	jal	80005a58 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	18050513          	addi	a0,a0,384 # 8000a2c0 <kmem>
    80000148:	111050ef          	jal	80005a58 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffe0601>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	24b000ef          	jal	80000d3a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	0000a717          	auipc	a4,0xa
    800002f8:	f9c70713          	addi	a4,a4,-100 # 8000a290 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000308:	233000ef          	jal	80000d3a <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	0aa050ef          	jal	800053c0 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	532010ef          	jal	80001850 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	656040ef          	jal	80004978 <plicinithart>
  }

  scheduler();        
    80000326:	675000ef          	jal	8000119a <scheduler>
    consoleinit();
    8000032a:	7c1040ef          	jal	800052ea <consoleinit>
    printfinit();
    8000032e:	39e050ef          	jal	800056cc <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	086050ef          	jal	800053c0 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	07a050ef          	jal	800053c0 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	06e050ef          	jal	800053c0 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	123000ef          	jal	80000c84 <procinit>
    trapinit();      // trap vectors
    80000366:	4c6010ef          	jal	8000182c <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	4e6010ef          	jal	80001850 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	5f0040ef          	jal	8000495e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	606040ef          	jal	80004978 <plicinithart>
    binit();         // buffer cache
    80000376:	30d010ef          	jal	80001e82 <binit>
    iinit();         // inode table
    8000037a:	1ac020ef          	jal	80002526 <iinit>
    fileinit();      // file table
    8000037e:	7f1020ef          	jal	8000336e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	6e6040ef          	jal	80004a68 <virtio_disk_init>
    userinit();      // first user process
    80000386:	449000ef          	jal	80000fce <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	f0f72023          	sw	a5,-256(a4) # 8000a290 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	0000a797          	auipc	a5,0xa
    800003a8:	ef47b783          	ld	a5,-268(a5) # 8000a298 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	84aa                	mv	s1,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fc63          	bgeu	a5,a1,8000041c <walk+0x5a>
    panic("walk");
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	2a2050ef          	jal	80005692 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8263          	beqz	s5,80000458 <walk+0x96>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	84aa                	mv	s1,a0
    800003fe:	c139                	beqz	a0,80000444 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c4d793          	srli	a5,s1,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffe05f7>
    80000418:	036a0063          	beq	s4,s6,80000438 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041c:	0149d933          	srl	s2,s3,s4
    80000420:	1ff97913          	andi	s2,s2,511
    80000424:	090e                	slli	s2,s2,0x3
    80000426:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000428:	00093483          	ld	s1,0(s2)
    8000042c:	0014f793          	andi	a5,s1,1
    80000430:	d3f1                	beqz	a5,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000432:	80a9                	srli	s1,s1,0xa
    80000434:	04b2                	slli	s1,s1,0xc
    80000436:	b7c5                	j	80000416 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
        return 0;
    80000458:	4501                	li	a0,0
    8000045a:	b7ed                	j	80000444 <walk+0x82>

000000008000045c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000045c:	57fd                	li	a5,-1
    8000045e:	83e9                	srli	a5,a5,0x1a
    80000460:	00b7f463          	bgeu	a5,a1,80000468 <walkaddr+0xc>
    return 0;
    80000464:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000466:	8082                	ret
{
    80000468:	1141                	addi	sp,sp,-16
    8000046a:	e406                	sd	ra,8(sp)
    8000046c:	e022                	sd	s0,0(sp)
    8000046e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000470:	4601                	li	a2,0
    80000472:	f51ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000476:	c105                	beqz	a0,80000496 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000478:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000047a:	0117f693          	andi	a3,a5,17
    8000047e:	4745                	li	a4,17
    return 0;
    80000480:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000482:	00e68663          	beq	a3,a4,8000048e <walkaddr+0x32>
}
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret
  pa = PTE2PA(*pte);
    8000048e:	83a9                	srli	a5,a5,0xa
    80000490:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000494:	bfcd                	j	80000486 <walkaddr+0x2a>
    return 0;
    80000496:	4501                	li	a0,0
    80000498:	b7fd                	j	80000486 <walkaddr+0x2a>

000000008000049a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000049a:	715d                	addi	sp,sp,-80
    8000049c:	e486                	sd	ra,72(sp)
    8000049e:	e0a2                	sd	s0,64(sp)
    800004a0:	fc26                	sd	s1,56(sp)
    800004a2:	f84a                	sd	s2,48(sp)
    800004a4:	f44e                	sd	s3,40(sp)
    800004a6:	f052                	sd	s4,32(sp)
    800004a8:	ec56                	sd	s5,24(sp)
    800004aa:	e85a                	sd	s6,16(sp)
    800004ac:	e45e                	sd	s7,8(sp)
    800004ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b0:	03459793          	slli	a5,a1,0x34
    800004b4:	e7a9                	bnez	a5,800004fe <mappages+0x64>
    800004b6:	8aaa                	mv	s5,a0
    800004b8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004ba:	03461793          	slli	a5,a2,0x34
    800004be:	e7b1                	bnez	a5,8000050a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c0:	ca39                	beqz	a2,80000516 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004c2:	77fd                	lui	a5,0xfffff
    800004c4:	963e                	add	a2,a2,a5
    800004c6:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ca:	892e                	mv	s2,a1
    800004cc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d0:	6b85                	lui	s7,0x1
    800004d2:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004d6:	4605                	li	a2,1
    800004d8:	85ca                	mv	a1,s2
    800004da:	8556                	mv	a0,s5
    800004dc:	ee7ff0ef          	jal	800003c2 <walk>
    800004e0:	c539                	beqz	a0,8000052e <mappages+0x94>
    if(*pte & PTE_V)
    800004e2:	611c                	ld	a5,0(a0)
    800004e4:	8b85                	andi	a5,a5,1
    800004e6:	ef95                	bnez	a5,80000522 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004e8:	80b1                	srli	s1,s1,0xc
    800004ea:	04aa                	slli	s1,s1,0xa
    800004ec:	0164e4b3          	or	s1,s1,s6
    800004f0:	0014e493          	ori	s1,s1,1
    800004f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800004f6:	05390863          	beq	s2,s3,80000546 <mappages+0xac>
    a += PGSIZE;
    800004fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	bfd9                	j	800004d2 <mappages+0x38>
    panic("mappages: va not aligned");
    800004fe:	00007517          	auipc	a0,0x7
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80007058 <etext+0x58>
    80000506:	18c050ef          	jal	80005692 <panic>
    panic("mappages: size not aligned");
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	180050ef          	jal	80005692 <panic>
    panic("mappages: size");
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	174050ef          	jal	80005692 <panic>
      panic("mappages: remap");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	168050ef          	jal	80005692 <panic>
      return -1;
    8000052e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000530:	60a6                	ld	ra,72(sp)
    80000532:	6406                	ld	s0,64(sp)
    80000534:	74e2                	ld	s1,56(sp)
    80000536:	7942                	ld	s2,48(sp)
    80000538:	79a2                	ld	s3,40(sp)
    8000053a:	7a02                	ld	s4,32(sp)
    8000053c:	6ae2                	ld	s5,24(sp)
    8000053e:	6b42                	ld	s6,16(sp)
    80000540:	6ba2                	ld	s7,8(sp)
    80000542:	6161                	addi	sp,sp,80
    80000544:	8082                	ret
  return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7e5                	j	80000530 <mappages+0x96>

000000008000054a <kvmmap>:
{
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e406                	sd	ra,8(sp)
    8000054e:	e022                	sd	s0,0(sp)
    80000550:	0800                	addi	s0,sp,16
    80000552:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000554:	86b2                	mv	a3,a2
    80000556:	863e                	mv	a2,a5
    80000558:	f43ff0ef          	jal	8000049a <mappages>
    8000055c:	e509                	bnez	a0,80000566 <kvmmap+0x1c>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
    panic("kvmmap");
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800070b8 <etext+0xb8>
    8000056e:	124050ef          	jal	80005692 <panic>

0000000080000572 <kvmmake>:
{
    80000572:	1101                	addi	sp,sp,-32
    80000574:	ec06                	sd	ra,24(sp)
    80000576:	e822                	sd	s0,16(sp)
    80000578:	e426                	sd	s1,8(sp)
    8000057a:	e04a                	sd	s2,0(sp)
    8000057c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000057e:	b81ff0ef          	jal	800000fe <kalloc>
    80000582:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000584:	6605                	lui	a2,0x1
    80000586:	4581                	li	a1,0
    80000588:	bc7ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000058c:	4719                	li	a4,6
    8000058e:	6685                	lui	a3,0x1
    80000590:	10000637          	lui	a2,0x10000
    80000594:	100005b7          	lui	a1,0x10000
    80000598:	8526                	mv	a0,s1
    8000059a:	fb1ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000059e:	4719                	li	a4,6
    800005a0:	6685                	lui	a3,0x1
    800005a2:	10001637          	lui	a2,0x10001
    800005a6:	100015b7          	lui	a1,0x10001
    800005aa:	8526                	mv	a0,s1
    800005ac:	f9fff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b0:	4719                	li	a4,6
    800005b2:	040006b7          	lui	a3,0x4000
    800005b6:	0c000637          	lui	a2,0xc000
    800005ba:	0c0005b7          	lui	a1,0xc000
    800005be:	8526                	mv	a0,s1
    800005c0:	f8bff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005c4:	00007917          	auipc	s2,0x7
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80007000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80007697          	auipc	a3,0x80007
    800005d2:	a3268693          	addi	a3,a3,-1486 # 7000 <_entry-0x7fff9000>
    800005d6:	4605                	li	a2,1
    800005d8:	067e                	slli	a2,a2,0x1f
    800005da:	85b2                	mv	a1,a2
    800005dc:	8526                	mv	a0,s1
    800005de:	f6dff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e2:	46c5                	li	a3,17
    800005e4:	06ee                	slli	a3,a3,0x1b
    800005e6:	4719                	li	a4,6
    800005e8:	412686b3          	sub	a3,a3,s2
    800005ec:	864a                	mv	a2,s2
    800005ee:	85ca                	mv	a1,s2
    800005f0:	8526                	mv	a0,s1
    800005f2:	f59ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005f6:	4729                	li	a4,10
    800005f8:	6685                	lui	a3,0x1
    800005fa:	00006617          	auipc	a2,0x6
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80006000 <_trampoline>
    80000602:	040005b7          	lui	a1,0x4000
    80000606:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000608:	05b2                	slli	a1,a1,0xc
    8000060a:	8526                	mv	a0,s1
    8000060c:	f3fff0ef          	jal	8000054a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000610:	8526                	mv	a0,s1
    80000612:	5da000ef          	jal	80000bec <proc_mapstacks>
}
    80000616:	8526                	mv	a0,s1
    80000618:	60e2                	ld	ra,24(sp)
    8000061a:	6442                	ld	s0,16(sp)
    8000061c:	64a2                	ld	s1,8(sp)
    8000061e:	6902                	ld	s2,0(sp)
    80000620:	6105                	addi	sp,sp,32
    80000622:	8082                	ret

0000000080000624 <kvminit>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000062c:	f47ff0ef          	jal	80000572 <kvmmake>
    80000630:	0000a797          	auipc	a5,0xa
    80000634:	c6a7b423          	sd	a0,-920(a5) # 8000a298 <kernel_pagetable>
}
    80000638:	60a2                	ld	ra,8(sp)
    8000063a:	6402                	ld	s0,0(sp)
    8000063c:	0141                	addi	sp,sp,16
    8000063e:	8082                	ret

0000000080000640 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000640:	715d                	addi	sp,sp,-80
    80000642:	e486                	sd	ra,72(sp)
    80000644:	e0a2                	sd	s0,64(sp)
    80000646:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000648:	03459793          	slli	a5,a1,0x34
    8000064c:	e39d                	bnez	a5,80000672 <uvmunmap+0x32>
    8000064e:	f84a                	sd	s2,48(sp)
    80000650:	f44e                	sd	s3,40(sp)
    80000652:	f052                	sd	s4,32(sp)
    80000654:	ec56                	sd	s5,24(sp)
    80000656:	e85a                	sd	s6,16(sp)
    80000658:	e45e                	sd	s7,8(sp)
    8000065a:	8a2a                	mv	s4,a0
    8000065c:	892e                	mv	s2,a1
    8000065e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000660:	0632                	slli	a2,a2,0xc
    80000662:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000666:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000668:	6b05                	lui	s6,0x1
    8000066a:	0735ff63          	bgeu	a1,s3,800006e8 <uvmunmap+0xa8>
    8000066e:	fc26                	sd	s1,56(sp)
    80000670:	a0a9                	j	800006ba <uvmunmap+0x7a>
    80000672:	fc26                	sd	s1,56(sp)
    80000674:	f84a                	sd	s2,48(sp)
    80000676:	f44e                	sd	s3,40(sp)
    80000678:	f052                	sd	s4,32(sp)
    8000067a:	ec56                	sd	s5,24(sp)
    8000067c:	e85a                	sd	s6,16(sp)
    8000067e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a4050513          	addi	a0,a0,-1472 # 800070c0 <etext+0xc0>
    80000688:	00a050ef          	jal	80005692 <panic>
      panic("uvmunmap: walk");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a4c50513          	addi	a0,a0,-1460 # 800070d8 <etext+0xd8>
    80000694:	7ff040ef          	jal	80005692 <panic>
      panic("uvmunmap: not mapped");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a5050513          	addi	a0,a0,-1456 # 800070e8 <etext+0xe8>
    800006a0:	7f3040ef          	jal	80005692 <panic>
      panic("uvmunmap: not a leaf");
    800006a4:	00007517          	auipc	a0,0x7
    800006a8:	a5c50513          	addi	a0,a0,-1444 # 80007100 <etext+0x100>
    800006ac:	7e7040ef          	jal	80005692 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006b0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006b4:	995a                	add	s2,s2,s6
    800006b6:	03397863          	bgeu	s2,s3,800006e6 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006ba:	4601                	li	a2,0
    800006bc:	85ca                	mv	a1,s2
    800006be:	8552                	mv	a0,s4
    800006c0:	d03ff0ef          	jal	800003c2 <walk>
    800006c4:	84aa                	mv	s1,a0
    800006c6:	d179                	beqz	a0,8000068c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    800006c8:	6108                	ld	a0,0(a0)
    800006ca:	00157793          	andi	a5,a0,1
    800006ce:	d7e9                	beqz	a5,80000698 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006d0:	3ff57793          	andi	a5,a0,1023
    800006d4:	fd7788e3          	beq	a5,s7,800006a4 <uvmunmap+0x64>
    if(do_free){
    800006d8:	fc0a8ce3          	beqz	s5,800006b0 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800006dc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006de:	0532                	slli	a0,a0,0xc
    800006e0:	93dff0ef          	jal	8000001c <kfree>
    800006e4:	b7f1                	j	800006b0 <uvmunmap+0x70>
    800006e6:	74e2                	ld	s1,56(sp)
    800006e8:	7942                	ld	s2,48(sp)
    800006ea:	79a2                	ld	s3,40(sp)
    800006ec:	7a02                	ld	s4,32(sp)
    800006ee:	6ae2                	ld	s5,24(sp)
    800006f0:	6b42                	ld	s6,16(sp)
    800006f2:	6ba2                	ld	s7,8(sp)
  }
}
    800006f4:	60a6                	ld	ra,72(sp)
    800006f6:	6406                	ld	s0,64(sp)
    800006f8:	6161                	addi	sp,sp,80
    800006fa:	8082                	ret

00000000800006fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006fc:	1101                	addi	sp,sp,-32
    800006fe:	ec06                	sd	ra,24(sp)
    80000700:	e822                	sd	s0,16(sp)
    80000702:	e426                	sd	s1,8(sp)
    80000704:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000706:	9f9ff0ef          	jal	800000fe <kalloc>
    8000070a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000070c:	c509                	beqz	a0,80000716 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000070e:	6605                	lui	a2,0x1
    80000710:	4581                	li	a1,0
    80000712:	a3dff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000716:	8526                	mv	a0,s1
    80000718:	60e2                	ld	ra,24(sp)
    8000071a:	6442                	ld	s0,16(sp)
    8000071c:	64a2                	ld	s1,8(sp)
    8000071e:	6105                	addi	sp,sp,32
    80000720:	8082                	ret

0000000080000722 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000722:	7179                	addi	sp,sp,-48
    80000724:	f406                	sd	ra,40(sp)
    80000726:	f022                	sd	s0,32(sp)
    80000728:	ec26                	sd	s1,24(sp)
    8000072a:	e84a                	sd	s2,16(sp)
    8000072c:	e44e                	sd	s3,8(sp)
    8000072e:	e052                	sd	s4,0(sp)
    80000730:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000732:	6785                	lui	a5,0x1
    80000734:	04f67063          	bgeu	a2,a5,80000774 <uvmfirst+0x52>
    80000738:	8a2a                	mv	s4,a0
    8000073a:	89ae                	mv	s3,a1
    8000073c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000073e:	9c1ff0ef          	jal	800000fe <kalloc>
    80000742:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000744:	6605                	lui	a2,0x1
    80000746:	4581                	li	a1,0
    80000748:	a07ff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000074c:	4779                	li	a4,30
    8000074e:	86ca                	mv	a3,s2
    80000750:	6605                	lui	a2,0x1
    80000752:	4581                	li	a1,0
    80000754:	8552                	mv	a0,s4
    80000756:	d45ff0ef          	jal	8000049a <mappages>
  memmove(mem, src, sz);
    8000075a:	8626                	mv	a2,s1
    8000075c:	85ce                	mv	a1,s3
    8000075e:	854a                	mv	a0,s2
    80000760:	a4bff0ef          	jal	800001aa <memmove>
}
    80000764:	70a2                	ld	ra,40(sp)
    80000766:	7402                	ld	s0,32(sp)
    80000768:	64e2                	ld	s1,24(sp)
    8000076a:	6942                	ld	s2,16(sp)
    8000076c:	69a2                	ld	s3,8(sp)
    8000076e:	6a02                	ld	s4,0(sp)
    80000770:	6145                	addi	sp,sp,48
    80000772:	8082                	ret
    panic("uvmfirst: more than a page");
    80000774:	00007517          	auipc	a0,0x7
    80000778:	9a450513          	addi	a0,a0,-1628 # 80007118 <etext+0x118>
    8000077c:	717040ef          	jal	80005692 <panic>

0000000080000780 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000780:	1101                	addi	sp,sp,-32
    80000782:	ec06                	sd	ra,24(sp)
    80000784:	e822                	sd	s0,16(sp)
    80000786:	e426                	sd	s1,8(sp)
    80000788:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000078a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000078c:	00b67d63          	bgeu	a2,a1,800007a6 <uvmdealloc+0x26>
    80000790:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000792:	6785                	lui	a5,0x1
    80000794:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000796:	00f60733          	add	a4,a2,a5
    8000079a:	76fd                	lui	a3,0xfffff
    8000079c:	8f75                	and	a4,a4,a3
    8000079e:	97ae                	add	a5,a5,a1
    800007a0:	8ff5                	and	a5,a5,a3
    800007a2:	00f76863          	bltu	a4,a5,800007b2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007a6:	8526                	mv	a0,s1
    800007a8:	60e2                	ld	ra,24(sp)
    800007aa:	6442                	ld	s0,16(sp)
    800007ac:	64a2                	ld	s1,8(sp)
    800007ae:	6105                	addi	sp,sp,32
    800007b0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007b2:	8f99                	sub	a5,a5,a4
    800007b4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007b6:	4685                	li	a3,1
    800007b8:	0007861b          	sext.w	a2,a5
    800007bc:	85ba                	mv	a1,a4
    800007be:	e83ff0ef          	jal	80000640 <uvmunmap>
    800007c2:	b7d5                	j	800007a6 <uvmdealloc+0x26>

00000000800007c4 <uvmalloc>:
  if(newsz < oldsz)
    800007c4:	08b66f63          	bltu	a2,a1,80000862 <uvmalloc+0x9e>
{
    800007c8:	7139                	addi	sp,sp,-64
    800007ca:	fc06                	sd	ra,56(sp)
    800007cc:	f822                	sd	s0,48(sp)
    800007ce:	ec4e                	sd	s3,24(sp)
    800007d0:	e852                	sd	s4,16(sp)
    800007d2:	e456                	sd	s5,8(sp)
    800007d4:	0080                	addi	s0,sp,64
    800007d6:	8aaa                	mv	s5,a0
    800007d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007da:	6785                	lui	a5,0x1
    800007dc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007de:	95be                	add	a1,a1,a5
    800007e0:	77fd                	lui	a5,0xfffff
    800007e2:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800007e6:	08c9f063          	bgeu	s3,a2,80000866 <uvmalloc+0xa2>
    800007ea:	f426                	sd	s1,40(sp)
    800007ec:	f04a                	sd	s2,32(sp)
    800007ee:	e05a                	sd	s6,0(sp)
    800007f0:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007f2:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007f6:	909ff0ef          	jal	800000fe <kalloc>
    800007fa:	84aa                	mv	s1,a0
    if(mem == 0){
    800007fc:	c515                	beqz	a0,80000828 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800007fe:	6605                	lui	a2,0x1
    80000800:	4581                	li	a1,0
    80000802:	94dff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000806:	875a                	mv	a4,s6
    80000808:	86a6                	mv	a3,s1
    8000080a:	6605                	lui	a2,0x1
    8000080c:	85ca                	mv	a1,s2
    8000080e:	8556                	mv	a0,s5
    80000810:	c8bff0ef          	jal	8000049a <mappages>
    80000814:	e915                	bnez	a0,80000848 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000816:	6785                	lui	a5,0x1
    80000818:	993e                	add	s2,s2,a5
    8000081a:	fd496ee3          	bltu	s2,s4,800007f6 <uvmalloc+0x32>
  return newsz;
    8000081e:	8552                	mv	a0,s4
    80000820:	74a2                	ld	s1,40(sp)
    80000822:	7902                	ld	s2,32(sp)
    80000824:	6b02                	ld	s6,0(sp)
    80000826:	a811                	j	8000083a <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000828:	864e                	mv	a2,s3
    8000082a:	85ca                	mv	a1,s2
    8000082c:	8556                	mv	a0,s5
    8000082e:	f53ff0ef          	jal	80000780 <uvmdealloc>
      return 0;
    80000832:	4501                	li	a0,0
    80000834:	74a2                	ld	s1,40(sp)
    80000836:	7902                	ld	s2,32(sp)
    80000838:	6b02                	ld	s6,0(sp)
}
    8000083a:	70e2                	ld	ra,56(sp)
    8000083c:	7442                	ld	s0,48(sp)
    8000083e:	69e2                	ld	s3,24(sp)
    80000840:	6a42                	ld	s4,16(sp)
    80000842:	6aa2                	ld	s5,8(sp)
    80000844:	6121                	addi	sp,sp,64
    80000846:	8082                	ret
      kfree(mem);
    80000848:	8526                	mv	a0,s1
    8000084a:	fd2ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000084e:	864e                	mv	a2,s3
    80000850:	85ca                	mv	a1,s2
    80000852:	8556                	mv	a0,s5
    80000854:	f2dff0ef          	jal	80000780 <uvmdealloc>
      return 0;
    80000858:	4501                	li	a0,0
    8000085a:	74a2                	ld	s1,40(sp)
    8000085c:	7902                	ld	s2,32(sp)
    8000085e:	6b02                	ld	s6,0(sp)
    80000860:	bfe9                	j	8000083a <uvmalloc+0x76>
    return oldsz;
    80000862:	852e                	mv	a0,a1
}
    80000864:	8082                	ret
  return newsz;
    80000866:	8532                	mv	a0,a2
    80000868:	bfc9                	j	8000083a <uvmalloc+0x76>

000000008000086a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000086a:	7179                	addi	sp,sp,-48
    8000086c:	f406                	sd	ra,40(sp)
    8000086e:	f022                	sd	s0,32(sp)
    80000870:	ec26                	sd	s1,24(sp)
    80000872:	e84a                	sd	s2,16(sp)
    80000874:	e44e                	sd	s3,8(sp)
    80000876:	e052                	sd	s4,0(sp)
    80000878:	1800                	addi	s0,sp,48
    8000087a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000087c:	84aa                	mv	s1,a0
    8000087e:	6905                	lui	s2,0x1
    80000880:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000882:	4985                	li	s3,1
    80000884:	a819                	j	8000089a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000886:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000888:	00c79513          	slli	a0,a5,0xc
    8000088c:	fdfff0ef          	jal	8000086a <freewalk>
      pagetable[i] = 0;
    80000890:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000894:	04a1                	addi	s1,s1,8
    80000896:	01248f63          	beq	s1,s2,800008b4 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000089a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000089c:	00f7f713          	andi	a4,a5,15
    800008a0:	ff3703e3          	beq	a4,s3,80000886 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008a4:	8b85                	andi	a5,a5,1
    800008a6:	d7fd                	beqz	a5,80000894 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008a8:	00007517          	auipc	a0,0x7
    800008ac:	89050513          	addi	a0,a0,-1904 # 80007138 <etext+0x138>
    800008b0:	5e3040ef          	jal	80005692 <panic>
    }
  }
  kfree((void*)pagetable);
    800008b4:	8552                	mv	a0,s4
    800008b6:	f66ff0ef          	jal	8000001c <kfree>
}
    800008ba:	70a2                	ld	ra,40(sp)
    800008bc:	7402                	ld	s0,32(sp)
    800008be:	64e2                	ld	s1,24(sp)
    800008c0:	6942                	ld	s2,16(sp)
    800008c2:	69a2                	ld	s3,8(sp)
    800008c4:	6a02                	ld	s4,0(sp)
    800008c6:	6145                	addi	sp,sp,48
    800008c8:	8082                	ret

00000000800008ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008ca:	1101                	addi	sp,sp,-32
    800008cc:	ec06                	sd	ra,24(sp)
    800008ce:	e822                	sd	s0,16(sp)
    800008d0:	e426                	sd	s1,8(sp)
    800008d2:	1000                	addi	s0,sp,32
    800008d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800008d6:	e989                	bnez	a1,800008e8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008d8:	8526                	mv	a0,s1
    800008da:	f91ff0ef          	jal	8000086a <freewalk>
}
    800008de:	60e2                	ld	ra,24(sp)
    800008e0:	6442                	ld	s0,16(sp)
    800008e2:	64a2                	ld	s1,8(sp)
    800008e4:	6105                	addi	sp,sp,32
    800008e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008e8:	6785                	lui	a5,0x1
    800008ea:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ec:	95be                	add	a1,a1,a5
    800008ee:	4685                	li	a3,1
    800008f0:	00c5d613          	srli	a2,a1,0xc
    800008f4:	4581                	li	a1,0
    800008f6:	d4bff0ef          	jal	80000640 <uvmunmap>
    800008fa:	bff9                	j	800008d8 <uvmfree+0xe>

00000000800008fc <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800008fc:	c65d                	beqz	a2,800009aa <uvmcopy+0xae>
{
    800008fe:	715d                	addi	sp,sp,-80
    80000900:	e486                	sd	ra,72(sp)
    80000902:	e0a2                	sd	s0,64(sp)
    80000904:	fc26                	sd	s1,56(sp)
    80000906:	f84a                	sd	s2,48(sp)
    80000908:	f44e                	sd	s3,40(sp)
    8000090a:	f052                	sd	s4,32(sp)
    8000090c:	ec56                	sd	s5,24(sp)
    8000090e:	e85a                	sd	s6,16(sp)
    80000910:	e45e                	sd	s7,8(sp)
    80000912:	0880                	addi	s0,sp,80
    80000914:	8b2a                	mv	s6,a0
    80000916:	8aae                	mv	s5,a1
    80000918:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000091a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000091c:	4601                	li	a2,0
    8000091e:	85ce                	mv	a1,s3
    80000920:	855a                	mv	a0,s6
    80000922:	aa1ff0ef          	jal	800003c2 <walk>
    80000926:	c121                	beqz	a0,80000966 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000928:	6118                	ld	a4,0(a0)
    8000092a:	00177793          	andi	a5,a4,1
    8000092e:	c3b1                	beqz	a5,80000972 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000930:	00a75593          	srli	a1,a4,0xa
    80000934:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000938:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000093c:	fc2ff0ef          	jal	800000fe <kalloc>
    80000940:	892a                	mv	s2,a0
    80000942:	c129                	beqz	a0,80000984 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000944:	6605                	lui	a2,0x1
    80000946:	85de                	mv	a1,s7
    80000948:	863ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000094c:	8726                	mv	a4,s1
    8000094e:	86ca                	mv	a3,s2
    80000950:	6605                	lui	a2,0x1
    80000952:	85ce                	mv	a1,s3
    80000954:	8556                	mv	a0,s5
    80000956:	b45ff0ef          	jal	8000049a <mappages>
    8000095a:	e115                	bnez	a0,8000097e <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	99be                	add	s3,s3,a5
    80000960:	fb49eee3          	bltu	s3,s4,8000091c <uvmcopy+0x20>
    80000964:	a805                	j	80000994 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000966:	00006517          	auipc	a0,0x6
    8000096a:	7e250513          	addi	a0,a0,2018 # 80007148 <etext+0x148>
    8000096e:	525040ef          	jal	80005692 <panic>
      panic("uvmcopy: page not present");
    80000972:	00006517          	auipc	a0,0x6
    80000976:	7f650513          	addi	a0,a0,2038 # 80007168 <etext+0x168>
    8000097a:	519040ef          	jal	80005692 <panic>
      kfree(mem);
    8000097e:	854a                	mv	a0,s2
    80000980:	e9cff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000984:	4685                	li	a3,1
    80000986:	00c9d613          	srli	a2,s3,0xc
    8000098a:	4581                	li	a1,0
    8000098c:	8556                	mv	a0,s5
    8000098e:	cb3ff0ef          	jal	80000640 <uvmunmap>
  return -1;
    80000992:	557d                	li	a0,-1
}
    80000994:	60a6                	ld	ra,72(sp)
    80000996:	6406                	ld	s0,64(sp)
    80000998:	74e2                	ld	s1,56(sp)
    8000099a:	7942                	ld	s2,48(sp)
    8000099c:	79a2                	ld	s3,40(sp)
    8000099e:	7a02                	ld	s4,32(sp)
    800009a0:	6ae2                	ld	s5,24(sp)
    800009a2:	6b42                	ld	s6,16(sp)
    800009a4:	6ba2                	ld	s7,8(sp)
    800009a6:	6161                	addi	sp,sp,80
    800009a8:	8082                	ret
  return 0;
    800009aa:	4501                	li	a0,0
}
    800009ac:	8082                	ret

00000000800009ae <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009ae:	1141                	addi	sp,sp,-16
    800009b0:	e406                	sd	ra,8(sp)
    800009b2:	e022                	sd	s0,0(sp)
    800009b4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009b6:	4601                	li	a2,0
    800009b8:	a0bff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    800009bc:	c901                	beqz	a0,800009cc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009be:	611c                	ld	a5,0(a0)
    800009c0:	9bbd                	andi	a5,a5,-17
    800009c2:	e11c                	sd	a5,0(a0)
}
    800009c4:	60a2                	ld	ra,8(sp)
    800009c6:	6402                	ld	s0,0(sp)
    800009c8:	0141                	addi	sp,sp,16
    800009ca:	8082                	ret
    panic("uvmclear");
    800009cc:	00006517          	auipc	a0,0x6
    800009d0:	7bc50513          	addi	a0,a0,1980 # 80007188 <etext+0x188>
    800009d4:	4bf040ef          	jal	80005692 <panic>

00000000800009d8 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009d8:	cad1                	beqz	a3,80000a6c <copyout+0x94>
{
    800009da:	711d                	addi	sp,sp,-96
    800009dc:	ec86                	sd	ra,88(sp)
    800009de:	e8a2                	sd	s0,80(sp)
    800009e0:	e4a6                	sd	s1,72(sp)
    800009e2:	fc4e                	sd	s3,56(sp)
    800009e4:	f456                	sd	s5,40(sp)
    800009e6:	f05a                	sd	s6,32(sp)
    800009e8:	ec5e                	sd	s7,24(sp)
    800009ea:	1080                	addi	s0,sp,96
    800009ec:	8baa                	mv	s7,a0
    800009ee:	8aae                	mv	s5,a1
    800009f0:	8b32                	mv	s6,a2
    800009f2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800009f4:	74fd                	lui	s1,0xfffff
    800009f6:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800009f8:	57fd                	li	a5,-1
    800009fa:	83e9                	srli	a5,a5,0x1a
    800009fc:	0697ea63          	bltu	a5,s1,80000a70 <copyout+0x98>
    80000a00:	e0ca                	sd	s2,64(sp)
    80000a02:	f852                	sd	s4,48(sp)
    80000a04:	e862                	sd	s8,16(sp)
    80000a06:	e466                	sd	s9,8(sp)
    80000a08:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a0a:	4cd5                	li	s9,21
    80000a0c:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000a0e:	8c3e                	mv	s8,a5
    80000a10:	a025                	j	80000a38 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a12:	83a9                	srli	a5,a5,0xa
    80000a14:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a16:	409a8533          	sub	a0,s5,s1
    80000a1a:	0009061b          	sext.w	a2,s2
    80000a1e:	85da                	mv	a1,s6
    80000a20:	953e                	add	a0,a0,a5
    80000a22:	f88ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000a26:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a2a:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a2c:	02098963          	beqz	s3,80000a5e <copyout+0x86>
    if(va0 >= MAXVA)
    80000a30:	054c6263          	bltu	s8,s4,80000a74 <copyout+0x9c>
    80000a34:	84d2                	mv	s1,s4
    80000a36:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a38:	4601                	li	a2,0
    80000a3a:	85a6                	mv	a1,s1
    80000a3c:	855e                	mv	a0,s7
    80000a3e:	985ff0ef          	jal	800003c2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a42:	c121                	beqz	a0,80000a82 <copyout+0xaa>
    80000a44:	611c                	ld	a5,0(a0)
    80000a46:	0157f713          	andi	a4,a5,21
    80000a4a:	05971b63          	bne	a4,s9,80000aa0 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000a4e:	01a48a33          	add	s4,s1,s10
    80000a52:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a56:	fb29fee3          	bgeu	s3,s2,80000a12 <copyout+0x3a>
    80000a5a:	894e                	mv	s2,s3
    80000a5c:	bf5d                	j	80000a12 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a5e:	4501                	li	a0,0
    80000a60:	6906                	ld	s2,64(sp)
    80000a62:	7a42                	ld	s4,48(sp)
    80000a64:	6c42                	ld	s8,16(sp)
    80000a66:	6ca2                	ld	s9,8(sp)
    80000a68:	6d02                	ld	s10,0(sp)
    80000a6a:	a015                	j	80000a8e <copyout+0xb6>
    80000a6c:	4501                	li	a0,0
}
    80000a6e:	8082                	ret
      return -1;
    80000a70:	557d                	li	a0,-1
    80000a72:	a831                	j	80000a8e <copyout+0xb6>
    80000a74:	557d                	li	a0,-1
    80000a76:	6906                	ld	s2,64(sp)
    80000a78:	7a42                	ld	s4,48(sp)
    80000a7a:	6c42                	ld	s8,16(sp)
    80000a7c:	6ca2                	ld	s9,8(sp)
    80000a7e:	6d02                	ld	s10,0(sp)
    80000a80:	a039                	j	80000a8e <copyout+0xb6>
      return -1;
    80000a82:	557d                	li	a0,-1
    80000a84:	6906                	ld	s2,64(sp)
    80000a86:	7a42                	ld	s4,48(sp)
    80000a88:	6c42                	ld	s8,16(sp)
    80000a8a:	6ca2                	ld	s9,8(sp)
    80000a8c:	6d02                	ld	s10,0(sp)
}
    80000a8e:	60e6                	ld	ra,88(sp)
    80000a90:	6446                	ld	s0,80(sp)
    80000a92:	64a6                	ld	s1,72(sp)
    80000a94:	79e2                	ld	s3,56(sp)
    80000a96:	7aa2                	ld	s5,40(sp)
    80000a98:	7b02                	ld	s6,32(sp)
    80000a9a:	6be2                	ld	s7,24(sp)
    80000a9c:	6125                	addi	sp,sp,96
    80000a9e:	8082                	ret
      return -1;
    80000aa0:	557d                	li	a0,-1
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	7a42                	ld	s4,48(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	6d02                	ld	s10,0(sp)
    80000aac:	b7cd                	j	80000a8e <copyout+0xb6>

0000000080000aae <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000aae:	c6a5                	beqz	a3,80000b16 <copyin+0x68>
{
    80000ab0:	715d                	addi	sp,sp,-80
    80000ab2:	e486                	sd	ra,72(sp)
    80000ab4:	e0a2                	sd	s0,64(sp)
    80000ab6:	fc26                	sd	s1,56(sp)
    80000ab8:	f84a                	sd	s2,48(sp)
    80000aba:	f44e                	sd	s3,40(sp)
    80000abc:	f052                	sd	s4,32(sp)
    80000abe:	ec56                	sd	s5,24(sp)
    80000ac0:	e85a                	sd	s6,16(sp)
    80000ac2:	e45e                	sd	s7,8(sp)
    80000ac4:	e062                	sd	s8,0(sp)
    80000ac6:	0880                	addi	s0,sp,80
    80000ac8:	8b2a                	mv	s6,a0
    80000aca:	8a2e                	mv	s4,a1
    80000acc:	8c32                	mv	s8,a2
    80000ace:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ad0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ad2:	6a85                	lui	s5,0x1
    80000ad4:	a00d                	j	80000af6 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ad6:	018505b3          	add	a1,a0,s8
    80000ada:	0004861b          	sext.w	a2,s1
    80000ade:	412585b3          	sub	a1,a1,s2
    80000ae2:	8552                	mv	a0,s4
    80000ae4:	ec6ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000ae8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000aec:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000aee:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000af2:	02098063          	beqz	s3,80000b12 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000af6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000afa:	85ca                	mv	a1,s2
    80000afc:	855a                	mv	a0,s6
    80000afe:	95fff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000b02:	cd01                	beqz	a0,80000b1a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b04:	418904b3          	sub	s1,s2,s8
    80000b08:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b0a:	fc99f6e3          	bgeu	s3,s1,80000ad6 <copyin+0x28>
    80000b0e:	84ce                	mv	s1,s3
    80000b10:	b7d9                	j	80000ad6 <copyin+0x28>
  }
  return 0;
    80000b12:	4501                	li	a0,0
    80000b14:	a021                	j	80000b1c <copyin+0x6e>
    80000b16:	4501                	li	a0,0
}
    80000b18:	8082                	ret
      return -1;
    80000b1a:	557d                	li	a0,-1
}
    80000b1c:	60a6                	ld	ra,72(sp)
    80000b1e:	6406                	ld	s0,64(sp)
    80000b20:	74e2                	ld	s1,56(sp)
    80000b22:	7942                	ld	s2,48(sp)
    80000b24:	79a2                	ld	s3,40(sp)
    80000b26:	7a02                	ld	s4,32(sp)
    80000b28:	6ae2                	ld	s5,24(sp)
    80000b2a:	6b42                	ld	s6,16(sp)
    80000b2c:	6ba2                	ld	s7,8(sp)
    80000b2e:	6c02                	ld	s8,0(sp)
    80000b30:	6161                	addi	sp,sp,80
    80000b32:	8082                	ret

0000000080000b34 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b34:	c6dd                	beqz	a3,80000be2 <copyinstr+0xae>
{
    80000b36:	715d                	addi	sp,sp,-80
    80000b38:	e486                	sd	ra,72(sp)
    80000b3a:	e0a2                	sd	s0,64(sp)
    80000b3c:	fc26                	sd	s1,56(sp)
    80000b3e:	f84a                	sd	s2,48(sp)
    80000b40:	f44e                	sd	s3,40(sp)
    80000b42:	f052                	sd	s4,32(sp)
    80000b44:	ec56                	sd	s5,24(sp)
    80000b46:	e85a                	sd	s6,16(sp)
    80000b48:	e45e                	sd	s7,8(sp)
    80000b4a:	0880                	addi	s0,sp,80
    80000b4c:	8a2a                	mv	s4,a0
    80000b4e:	8b2e                	mv	s6,a1
    80000b50:	8bb2                	mv	s7,a2
    80000b52:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b54:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b56:	6985                	lui	s3,0x1
    80000b58:	a825                	j	80000b90 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b5a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b5e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b60:	37fd                	addiw	a5,a5,-1
    80000b62:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b66:	60a6                	ld	ra,72(sp)
    80000b68:	6406                	ld	s0,64(sp)
    80000b6a:	74e2                	ld	s1,56(sp)
    80000b6c:	7942                	ld	s2,48(sp)
    80000b6e:	79a2                	ld	s3,40(sp)
    80000b70:	7a02                	ld	s4,32(sp)
    80000b72:	6ae2                	ld	s5,24(sp)
    80000b74:	6b42                	ld	s6,16(sp)
    80000b76:	6ba2                	ld	s7,8(sp)
    80000b78:	6161                	addi	sp,sp,80
    80000b7a:	8082                	ret
    80000b7c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b80:	9742                	add	a4,a4,a6
      --max;
    80000b82:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000b86:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000b8a:	04e58463          	beq	a1,a4,80000bd2 <copyinstr+0x9e>
{
    80000b8e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000b90:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b94:	85a6                	mv	a1,s1
    80000b96:	8552                	mv	a0,s4
    80000b98:	8c5ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000b9c:	cd0d                	beqz	a0,80000bd6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000b9e:	417486b3          	sub	a3,s1,s7
    80000ba2:	96ce                	add	a3,a3,s3
    if(n > max)
    80000ba4:	00d97363          	bgeu	s2,a3,80000baa <copyinstr+0x76>
    80000ba8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000baa:	955e                	add	a0,a0,s7
    80000bac:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bae:	c695                	beqz	a3,80000bda <copyinstr+0xa6>
    80000bb0:	87da                	mv	a5,s6
    80000bb2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bb4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bb8:	96da                	add	a3,a3,s6
    80000bba:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bbc:	00f60733          	add	a4,a2,a5
    80000bc0:	00074703          	lbu	a4,0(a4)
    80000bc4:	db59                	beqz	a4,80000b5a <copyinstr+0x26>
        *dst = *p;
    80000bc6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bca:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bcc:	fed797e3          	bne	a5,a3,80000bba <copyinstr+0x86>
    80000bd0:	b775                	j	80000b7c <copyinstr+0x48>
    80000bd2:	4781                	li	a5,0
    80000bd4:	b771                	j	80000b60 <copyinstr+0x2c>
      return -1;
    80000bd6:	557d                	li	a0,-1
    80000bd8:	b779                	j	80000b66 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bda:	6b85                	lui	s7,0x1
    80000bdc:	9ba6                	add	s7,s7,s1
    80000bde:	87da                	mv	a5,s6
    80000be0:	b77d                	j	80000b8e <copyinstr+0x5a>
  int got_null = 0;
    80000be2:	4781                	li	a5,0
  if(got_null){
    80000be4:	37fd                	addiw	a5,a5,-1
    80000be6:	0007851b          	sext.w	a0,a5
}
    80000bea:	8082                	ret

0000000080000bec <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bec:	7139                	addi	sp,sp,-64
    80000bee:	fc06                	sd	ra,56(sp)
    80000bf0:	f822                	sd	s0,48(sp)
    80000bf2:	f426                	sd	s1,40(sp)
    80000bf4:	f04a                	sd	s2,32(sp)
    80000bf6:	ec4e                	sd	s3,24(sp)
    80000bf8:	e852                	sd	s4,16(sp)
    80000bfa:	e456                	sd	s5,8(sp)
    80000bfc:	e05a                	sd	s6,0(sp)
    80000bfe:	0080                	addi	s0,sp,64
    80000c00:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c02:	0000a497          	auipc	s1,0xa
    80000c06:	b0e48493          	addi	s1,s1,-1266 # 8000a710 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c0a:	8b26                	mv	s6,s1
    80000c0c:	04fa5937          	lui	s2,0x4fa5
    80000c10:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c14:	0932                	slli	s2,s2,0xc
    80000c16:	fa590913          	addi	s2,s2,-91
    80000c1a:	0932                	slli	s2,s2,0xc
    80000c1c:	fa590913          	addi	s2,s2,-91
    80000c20:	0932                	slli	s2,s2,0xc
    80000c22:	fa590913          	addi	s2,s2,-91
    80000c26:	040009b7          	lui	s3,0x4000
    80000c2a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c2c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c2e:	0000ba97          	auipc	s5,0xb
    80000c32:	8f2a8a93          	addi	s5,s5,-1806 # 8000b520 <tickslock>
    char *pa = kalloc();
    80000c36:	cc8ff0ef          	jal	800000fe <kalloc>
    80000c3a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c3c:	cd15                	beqz	a0,80000c78 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c3e:	416485b3          	sub	a1,s1,s6
    80000c42:	858d                	srai	a1,a1,0x3
    80000c44:	032585b3          	mul	a1,a1,s2
    80000c48:	2585                	addiw	a1,a1,1
    80000c4a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c4e:	4719                	li	a4,6
    80000c50:	6685                	lui	a3,0x1
    80000c52:	40b985b3          	sub	a1,s3,a1
    80000c56:	8552                	mv	a0,s4
    80000c58:	8f3ff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c5c:	16848493          	addi	s1,s1,360
    80000c60:	fd549be3          	bne	s1,s5,80000c36 <proc_mapstacks+0x4a>
  }
}
    80000c64:	70e2                	ld	ra,56(sp)
    80000c66:	7442                	ld	s0,48(sp)
    80000c68:	74a2                	ld	s1,40(sp)
    80000c6a:	7902                	ld	s2,32(sp)
    80000c6c:	69e2                	ld	s3,24(sp)
    80000c6e:	6a42                	ld	s4,16(sp)
    80000c70:	6aa2                	ld	s5,8(sp)
    80000c72:	6b02                	ld	s6,0(sp)
    80000c74:	6121                	addi	sp,sp,64
    80000c76:	8082                	ret
      panic("kalloc");
    80000c78:	00006517          	auipc	a0,0x6
    80000c7c:	52050513          	addi	a0,a0,1312 # 80007198 <etext+0x198>
    80000c80:	213040ef          	jal	80005692 <panic>

0000000080000c84 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c84:	7139                	addi	sp,sp,-64
    80000c86:	fc06                	sd	ra,56(sp)
    80000c88:	f822                	sd	s0,48(sp)
    80000c8a:	f426                	sd	s1,40(sp)
    80000c8c:	f04a                	sd	s2,32(sp)
    80000c8e:	ec4e                	sd	s3,24(sp)
    80000c90:	e852                	sd	s4,16(sp)
    80000c92:	e456                	sd	s5,8(sp)
    80000c94:	e05a                	sd	s6,0(sp)
    80000c96:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c98:	00006597          	auipc	a1,0x6
    80000c9c:	50858593          	addi	a1,a1,1288 # 800071a0 <etext+0x1a0>
    80000ca0:	00009517          	auipc	a0,0x9
    80000ca4:	64050513          	addi	a0,a0,1600 # 8000a2e0 <pid_lock>
    80000ca8:	499040ef          	jal	80005940 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cac:	00006597          	auipc	a1,0x6
    80000cb0:	4fc58593          	addi	a1,a1,1276 # 800071a8 <etext+0x1a8>
    80000cb4:	00009517          	auipc	a0,0x9
    80000cb8:	64450513          	addi	a0,a0,1604 # 8000a2f8 <wait_lock>
    80000cbc:	485040ef          	jal	80005940 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cc0:	0000a497          	auipc	s1,0xa
    80000cc4:	a5048493          	addi	s1,s1,-1456 # 8000a710 <proc>
      initlock(&p->lock, "proc");
    80000cc8:	00006b17          	auipc	s6,0x6
    80000ccc:	4f0b0b13          	addi	s6,s6,1264 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cd0:	8aa6                	mv	s5,s1
    80000cd2:	04fa5937          	lui	s2,0x4fa5
    80000cd6:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000cda:	0932                	slli	s2,s2,0xc
    80000cdc:	fa590913          	addi	s2,s2,-91
    80000ce0:	0932                	slli	s2,s2,0xc
    80000ce2:	fa590913          	addi	s2,s2,-91
    80000ce6:	0932                	slli	s2,s2,0xc
    80000ce8:	fa590913          	addi	s2,s2,-91
    80000cec:	040009b7          	lui	s3,0x4000
    80000cf0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000cf2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	0000ba17          	auipc	s4,0xb
    80000cf8:	82ca0a13          	addi	s4,s4,-2004 # 8000b520 <tickslock>
      initlock(&p->lock, "proc");
    80000cfc:	85da                	mv	a1,s6
    80000cfe:	8526                	mv	a0,s1
    80000d00:	441040ef          	jal	80005940 <initlock>
      p->state = UNUSED;
    80000d04:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d08:	415487b3          	sub	a5,s1,s5
    80000d0c:	878d                	srai	a5,a5,0x3
    80000d0e:	032787b3          	mul	a5,a5,s2
    80000d12:	2785                	addiw	a5,a5,1
    80000d14:	00d7979b          	slliw	a5,a5,0xd
    80000d18:	40f987b3          	sub	a5,s3,a5
    80000d1c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d1e:	16848493          	addi	s1,s1,360
    80000d22:	fd449de3          	bne	s1,s4,80000cfc <procinit+0x78>
  }
}
    80000d26:	70e2                	ld	ra,56(sp)
    80000d28:	7442                	ld	s0,48(sp)
    80000d2a:	74a2                	ld	s1,40(sp)
    80000d2c:	7902                	ld	s2,32(sp)
    80000d2e:	69e2                	ld	s3,24(sp)
    80000d30:	6a42                	ld	s4,16(sp)
    80000d32:	6aa2                	ld	s5,8(sp)
    80000d34:	6b02                	ld	s6,0(sp)
    80000d36:	6121                	addi	sp,sp,64
    80000d38:	8082                	ret

0000000080000d3a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d40:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d42:	2501                	sext.w	a0,a0
    80000d44:	6422                	ld	s0,8(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret

0000000080000d4a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d4a:	1141                	addi	sp,sp,-16
    80000d4c:	e422                	sd	s0,8(sp)
    80000d4e:	0800                	addi	s0,sp,16
    80000d50:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d52:	2781                	sext.w	a5,a5
    80000d54:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d56:	00009517          	auipc	a0,0x9
    80000d5a:	5ba50513          	addi	a0,a0,1466 # 8000a310 <cpus>
    80000d5e:	953e                	add	a0,a0,a5
    80000d60:	6422                	ld	s0,8(sp)
    80000d62:	0141                	addi	sp,sp,16
    80000d64:	8082                	ret

0000000080000d66 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d66:	1101                	addi	sp,sp,-32
    80000d68:	ec06                	sd	ra,24(sp)
    80000d6a:	e822                	sd	s0,16(sp)
    80000d6c:	e426                	sd	s1,8(sp)
    80000d6e:	1000                	addi	s0,sp,32
  push_off();
    80000d70:	411040ef          	jal	80005980 <push_off>
    80000d74:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d76:	2781                	sext.w	a5,a5
    80000d78:	079e                	slli	a5,a5,0x7
    80000d7a:	00009717          	auipc	a4,0x9
    80000d7e:	56670713          	addi	a4,a4,1382 # 8000a2e0 <pid_lock>
    80000d82:	97ba                	add	a5,a5,a4
    80000d84:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d86:	47f040ef          	jal	80005a04 <pop_off>
  return p;
}
    80000d8a:	8526                	mv	a0,s1
    80000d8c:	60e2                	ld	ra,24(sp)
    80000d8e:	6442                	ld	s0,16(sp)
    80000d90:	64a2                	ld	s1,8(sp)
    80000d92:	6105                	addi	sp,sp,32
    80000d94:	8082                	ret

0000000080000d96 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e406                	sd	ra,8(sp)
    80000d9a:	e022                	sd	s0,0(sp)
    80000d9c:	0800                	addi	s0,sp,16
  static int first = 1;
  
  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d9e:	fc9ff0ef          	jal	80000d66 <myproc>
    80000da2:	4b7040ef          	jal	80005a58 <release>

  if (first) {
    80000da6:	00009797          	auipc	a5,0x9
    80000daa:	47a7a783          	lw	a5,1146(a5) # 8000a220 <first.1>
    80000dae:	e799                	bnez	a5,80000dbc <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000db0:	2b9000ef          	jal	80001868 <usertrapret>
}
    80000db4:	60a2                	ld	ra,8(sp)
    80000db6:	6402                	ld	s0,0(sp)
    80000db8:	0141                	addi	sp,sp,16
    80000dba:	8082                	ret
    fsinit(ROOTDEV);
    80000dbc:	4505                	li	a0,1
    80000dbe:	6fc010ef          	jal	800024ba <fsinit>
    first = 0;
    80000dc2:	00009797          	auipc	a5,0x9
    80000dc6:	4407af23          	sw	zero,1118(a5) # 8000a220 <first.1>
    __sync_synchronize();
    80000dca:	0330000f          	fence	rw,rw
    80000dce:	b7cd                	j	80000db0 <forkret+0x1a>

0000000080000dd0 <allocpid>:
{
    80000dd0:	1101                	addi	sp,sp,-32
    80000dd2:	ec06                	sd	ra,24(sp)
    80000dd4:	e822                	sd	s0,16(sp)
    80000dd6:	e426                	sd	s1,8(sp)
    80000dd8:	e04a                	sd	s2,0(sp)
    80000dda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ddc:	00009917          	auipc	s2,0x9
    80000de0:	50490913          	addi	s2,s2,1284 # 8000a2e0 <pid_lock>
    80000de4:	854a                	mv	a0,s2
    80000de6:	3db040ef          	jal	800059c0 <acquire>
  pid = nextpid;
    80000dea:	00009797          	auipc	a5,0x9
    80000dee:	43a78793          	addi	a5,a5,1082 # 8000a224 <nextpid>
    80000df2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000df4:	0014871b          	addiw	a4,s1,1
    80000df8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dfa:	854a                	mv	a0,s2
    80000dfc:	45d040ef          	jal	80005a58 <release>
}
    80000e00:	8526                	mv	a0,s1
    80000e02:	60e2                	ld	ra,24(sp)
    80000e04:	6442                	ld	s0,16(sp)
    80000e06:	64a2                	ld	s1,8(sp)
    80000e08:	6902                	ld	s2,0(sp)
    80000e0a:	6105                	addi	sp,sp,32
    80000e0c:	8082                	ret

0000000080000e0e <proc_pagetable>:
{
    80000e0e:	1101                	addi	sp,sp,-32
    80000e10:	ec06                	sd	ra,24(sp)
    80000e12:	e822                	sd	s0,16(sp)
    80000e14:	e426                	sd	s1,8(sp)
    80000e16:	e04a                	sd	s2,0(sp)
    80000e18:	1000                	addi	s0,sp,32
    80000e1a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e1c:	8e1ff0ef          	jal	800006fc <uvmcreate>
    80000e20:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e22:	cd05                	beqz	a0,80000e5a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e24:	4729                	li	a4,10
    80000e26:	00005697          	auipc	a3,0x5
    80000e2a:	1da68693          	addi	a3,a3,474 # 80006000 <_trampoline>
    80000e2e:	6605                	lui	a2,0x1
    80000e30:	040005b7          	lui	a1,0x4000
    80000e34:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e36:	05b2                	slli	a1,a1,0xc
    80000e38:	e62ff0ef          	jal	8000049a <mappages>
    80000e3c:	02054663          	bltz	a0,80000e68 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e40:	4719                	li	a4,6
    80000e42:	05893683          	ld	a3,88(s2)
    80000e46:	6605                	lui	a2,0x1
    80000e48:	020005b7          	lui	a1,0x2000
    80000e4c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e4e:	05b6                	slli	a1,a1,0xd
    80000e50:	8526                	mv	a0,s1
    80000e52:	e48ff0ef          	jal	8000049a <mappages>
    80000e56:	00054f63          	bltz	a0,80000e74 <proc_pagetable+0x66>
}
    80000e5a:	8526                	mv	a0,s1
    80000e5c:	60e2                	ld	ra,24(sp)
    80000e5e:	6442                	ld	s0,16(sp)
    80000e60:	64a2                	ld	s1,8(sp)
    80000e62:	6902                	ld	s2,0(sp)
    80000e64:	6105                	addi	sp,sp,32
    80000e66:	8082                	ret
    uvmfree(pagetable, 0);
    80000e68:	4581                	li	a1,0
    80000e6a:	8526                	mv	a0,s1
    80000e6c:	a5fff0ef          	jal	800008ca <uvmfree>
    return 0;
    80000e70:	4481                	li	s1,0
    80000e72:	b7e5                	j	80000e5a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e74:	4681                	li	a3,0
    80000e76:	4605                	li	a2,1
    80000e78:	040005b7          	lui	a1,0x4000
    80000e7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e7e:	05b2                	slli	a1,a1,0xc
    80000e80:	8526                	mv	a0,s1
    80000e82:	fbeff0ef          	jal	80000640 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e86:	4581                	li	a1,0
    80000e88:	8526                	mv	a0,s1
    80000e8a:	a41ff0ef          	jal	800008ca <uvmfree>
    return 0;
    80000e8e:	4481                	li	s1,0
    80000e90:	b7e9                	j	80000e5a <proc_pagetable+0x4c>

0000000080000e92 <proc_freepagetable>:
{
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	e04a                	sd	s2,0(sp)
    80000e9c:	1000                	addi	s0,sp,32
    80000e9e:	84aa                	mv	s1,a0
    80000ea0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ea2:	4681                	li	a3,0
    80000ea4:	4605                	li	a2,1
    80000ea6:	040005b7          	lui	a1,0x4000
    80000eaa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eac:	05b2                	slli	a1,a1,0xc
    80000eae:	f92ff0ef          	jal	80000640 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000eb2:	4681                	li	a3,0
    80000eb4:	4605                	li	a2,1
    80000eb6:	020005b7          	lui	a1,0x2000
    80000eba:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ebc:	05b6                	slli	a1,a1,0xd
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	f80ff0ef          	jal	80000640 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ec4:	85ca                	mv	a1,s2
    80000ec6:	8526                	mv	a0,s1
    80000ec8:	a03ff0ef          	jal	800008ca <uvmfree>
}
    80000ecc:	60e2                	ld	ra,24(sp)
    80000ece:	6442                	ld	s0,16(sp)
    80000ed0:	64a2                	ld	s1,8(sp)
    80000ed2:	6902                	ld	s2,0(sp)
    80000ed4:	6105                	addi	sp,sp,32
    80000ed6:	8082                	ret

0000000080000ed8 <freeproc>:
{
    80000ed8:	1101                	addi	sp,sp,-32
    80000eda:	ec06                	sd	ra,24(sp)
    80000edc:	e822                	sd	s0,16(sp)
    80000ede:	e426                	sd	s1,8(sp)
    80000ee0:	1000                	addi	s0,sp,32
    80000ee2:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ee4:	6d28                	ld	a0,88(a0)
    80000ee6:	c119                	beqz	a0,80000eec <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ee8:	934ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000eec:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ef0:	68a8                	ld	a0,80(s1)
    80000ef2:	c501                	beqz	a0,80000efa <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ef4:	64ac                	ld	a1,72(s1)
    80000ef6:	f9dff0ef          	jal	80000e92 <proc_freepagetable>
  p->pagetable = 0;
    80000efa:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000efe:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f02:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f06:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f0a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f0e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f12:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f16:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f1a:	0004ac23          	sw	zero,24(s1)
}
    80000f1e:	60e2                	ld	ra,24(sp)
    80000f20:	6442                	ld	s0,16(sp)
    80000f22:	64a2                	ld	s1,8(sp)
    80000f24:	6105                	addi	sp,sp,32
    80000f26:	8082                	ret

0000000080000f28 <allocproc>:
{
    80000f28:	1101                	addi	sp,sp,-32
    80000f2a:	ec06                	sd	ra,24(sp)
    80000f2c:	e822                	sd	s0,16(sp)
    80000f2e:	e426                	sd	s1,8(sp)
    80000f30:	e04a                	sd	s2,0(sp)
    80000f32:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f34:	00009497          	auipc	s1,0x9
    80000f38:	7dc48493          	addi	s1,s1,2012 # 8000a710 <proc>
    80000f3c:	0000a917          	auipc	s2,0xa
    80000f40:	5e490913          	addi	s2,s2,1508 # 8000b520 <tickslock>
    acquire(&p->lock);
    80000f44:	8526                	mv	a0,s1
    80000f46:	27b040ef          	jal	800059c0 <acquire>
    if(p->state == UNUSED) {
    80000f4a:	4c9c                	lw	a5,24(s1)
    80000f4c:	c385                	beqz	a5,80000f6c <allocproc+0x44>
      release(&p->lock);
    80000f4e:	8526                	mv	a0,s1
    80000f50:	309040ef          	jal	80005a58 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f54:	16848493          	addi	s1,s1,360
    80000f58:	ff2496e3          	bne	s1,s2,80000f44 <allocproc+0x1c>
  return 0;
    80000f5c:	4481                	li	s1,0
}
    80000f5e:	8526                	mv	a0,s1
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6902                	ld	s2,0(sp)
    80000f68:	6105                	addi	sp,sp,32
    80000f6a:	8082                	ret
  p->pid = allocpid();
    80000f6c:	e65ff0ef          	jal	80000dd0 <allocpid>
    80000f70:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f72:	4785                	li	a5,1
    80000f74:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f76:	988ff0ef          	jal	800000fe <kalloc>
    80000f7a:	892a                	mv	s2,a0
    80000f7c:	eca8                	sd	a0,88(s1)
    80000f7e:	c905                	beqz	a0,80000fae <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f80:	8526                	mv	a0,s1
    80000f82:	e8dff0ef          	jal	80000e0e <proc_pagetable>
    80000f86:	892a                	mv	s2,a0
    80000f88:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f8a:	c915                	beqz	a0,80000fbe <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f8c:	07000613          	li	a2,112
    80000f90:	4581                	li	a1,0
    80000f92:	06048513          	addi	a0,s1,96
    80000f96:	9b8ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000f9a:	00000797          	auipc	a5,0x0
    80000f9e:	dfc78793          	addi	a5,a5,-516 # 80000d96 <forkret>
    80000fa2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fa4:	60bc                	ld	a5,64(s1)
    80000fa6:	6705                	lui	a4,0x1
    80000fa8:	97ba                	add	a5,a5,a4
    80000faa:	f4bc                	sd	a5,104(s1)
  return p;
    80000fac:	bf4d                	j	80000f5e <allocproc+0x36>
    freeproc(p);
    80000fae:	8526                	mv	a0,s1
    80000fb0:	f29ff0ef          	jal	80000ed8 <freeproc>
    release(&p->lock);
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	2a3040ef          	jal	80005a58 <release>
    return 0;
    80000fba:	84ca                	mv	s1,s2
    80000fbc:	b74d                	j	80000f5e <allocproc+0x36>
    freeproc(p);
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	f19ff0ef          	jal	80000ed8 <freeproc>
    release(&p->lock);
    80000fc4:	8526                	mv	a0,s1
    80000fc6:	293040ef          	jal	80005a58 <release>
    return 0;
    80000fca:	84ca                	mv	s1,s2
    80000fcc:	bf49                	j	80000f5e <allocproc+0x36>

0000000080000fce <userinit>:
{
    80000fce:	1101                	addi	sp,sp,-32
    80000fd0:	ec06                	sd	ra,24(sp)
    80000fd2:	e822                	sd	s0,16(sp)
    80000fd4:	e426                	sd	s1,8(sp)
    80000fd6:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fd8:	f51ff0ef          	jal	80000f28 <allocproc>
    80000fdc:	84aa                	mv	s1,a0
  initproc = p;
    80000fde:	00009797          	auipc	a5,0x9
    80000fe2:	2ca7b123          	sd	a0,706(a5) # 8000a2a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fe6:	03400613          	li	a2,52
    80000fea:	00009597          	auipc	a1,0x9
    80000fee:	24658593          	addi	a1,a1,582 # 8000a230 <initcode>
    80000ff2:	6928                	ld	a0,80(a0)
    80000ff4:	f2eff0ef          	jal	80000722 <uvmfirst>
  p->sz = PGSIZE;
    80000ff8:	6785                	lui	a5,0x1
    80000ffa:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ffc:	6cb8                	ld	a4,88(s1)
    80000ffe:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001002:	6cb8                	ld	a4,88(s1)
    80001004:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001006:	4641                	li	a2,16
    80001008:	00006597          	auipc	a1,0x6
    8000100c:	1b858593          	addi	a1,a1,440 # 800071c0 <etext+0x1c0>
    80001010:	15848513          	addi	a0,s1,344
    80001014:	a78ff0ef          	jal	8000028c <safestrcpy>
  p->cwd = namei("/");
    80001018:	00006517          	auipc	a0,0x6
    8000101c:	1b850513          	addi	a0,a0,440 # 800071d0 <etext+0x1d0>
    80001020:	641010ef          	jal	80002e60 <namei>
    80001024:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001028:	478d                	li	a5,3
    8000102a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000102c:	8526                	mv	a0,s1
    8000102e:	22b040ef          	jal	80005a58 <release>
}
    80001032:	60e2                	ld	ra,24(sp)
    80001034:	6442                	ld	s0,16(sp)
    80001036:	64a2                	ld	s1,8(sp)
    80001038:	6105                	addi	sp,sp,32
    8000103a:	8082                	ret

000000008000103c <growproc>:
{
    8000103c:	1101                	addi	sp,sp,-32
    8000103e:	ec06                	sd	ra,24(sp)
    80001040:	e822                	sd	s0,16(sp)
    80001042:	e426                	sd	s1,8(sp)
    80001044:	e04a                	sd	s2,0(sp)
    80001046:	1000                	addi	s0,sp,32
    80001048:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000104a:	d1dff0ef          	jal	80000d66 <myproc>
    8000104e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001050:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001052:	01204c63          	bgtz	s2,8000106a <growproc+0x2e>
  } else if(n < 0){
    80001056:	02094463          	bltz	s2,8000107e <growproc+0x42>
  p->sz = sz;
    8000105a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000105c:	4501                	li	a0,0
}
    8000105e:	60e2                	ld	ra,24(sp)
    80001060:	6442                	ld	s0,16(sp)
    80001062:	64a2                	ld	s1,8(sp)
    80001064:	6902                	ld	s2,0(sp)
    80001066:	6105                	addi	sp,sp,32
    80001068:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000106a:	4691                	li	a3,4
    8000106c:	00b90633          	add	a2,s2,a1
    80001070:	6928                	ld	a0,80(a0)
    80001072:	f52ff0ef          	jal	800007c4 <uvmalloc>
    80001076:	85aa                	mv	a1,a0
    80001078:	f16d                	bnez	a0,8000105a <growproc+0x1e>
      return -1;
    8000107a:	557d                	li	a0,-1
    8000107c:	b7cd                	j	8000105e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000107e:	00b90633          	add	a2,s2,a1
    80001082:	6928                	ld	a0,80(a0)
    80001084:	efcff0ef          	jal	80000780 <uvmdealloc>
    80001088:	85aa                	mv	a1,a0
    8000108a:	bfc1                	j	8000105a <growproc+0x1e>

000000008000108c <fork>:
{
    8000108c:	7139                	addi	sp,sp,-64
    8000108e:	fc06                	sd	ra,56(sp)
    80001090:	f822                	sd	s0,48(sp)
    80001092:	f04a                	sd	s2,32(sp)
    80001094:	e456                	sd	s5,8(sp)
    80001096:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001098:	ccfff0ef          	jal	80000d66 <myproc>
    8000109c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000109e:	e8bff0ef          	jal	80000f28 <allocproc>
    800010a2:	0e050a63          	beqz	a0,80001196 <fork+0x10a>
    800010a6:	e852                	sd	s4,16(sp)
    800010a8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010aa:	048ab603          	ld	a2,72(s5)
    800010ae:	692c                	ld	a1,80(a0)
    800010b0:	050ab503          	ld	a0,80(s5)
    800010b4:	849ff0ef          	jal	800008fc <uvmcopy>
    800010b8:	04054a63          	bltz	a0,8000110c <fork+0x80>
    800010bc:	f426                	sd	s1,40(sp)
    800010be:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010c0:	048ab783          	ld	a5,72(s5)
    800010c4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010c8:	058ab683          	ld	a3,88(s5)
    800010cc:	87b6                	mv	a5,a3
    800010ce:	058a3703          	ld	a4,88(s4)
    800010d2:	12068693          	addi	a3,a3,288
    800010d6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010da:	6788                	ld	a0,8(a5)
    800010dc:	6b8c                	ld	a1,16(a5)
    800010de:	6f90                	ld	a2,24(a5)
    800010e0:	01073023          	sd	a6,0(a4)
    800010e4:	e708                	sd	a0,8(a4)
    800010e6:	eb0c                	sd	a1,16(a4)
    800010e8:	ef10                	sd	a2,24(a4)
    800010ea:	02078793          	addi	a5,a5,32
    800010ee:	02070713          	addi	a4,a4,32
    800010f2:	fed792e3          	bne	a5,a3,800010d6 <fork+0x4a>
  np->trapframe->a0 = 0;
    800010f6:	058a3783          	ld	a5,88(s4)
    800010fa:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010fe:	0d0a8493          	addi	s1,s5,208
    80001102:	0d0a0913          	addi	s2,s4,208
    80001106:	150a8993          	addi	s3,s5,336
    8000110a:	a831                	j	80001126 <fork+0x9a>
    freeproc(np);
    8000110c:	8552                	mv	a0,s4
    8000110e:	dcbff0ef          	jal	80000ed8 <freeproc>
    release(&np->lock);
    80001112:	8552                	mv	a0,s4
    80001114:	145040ef          	jal	80005a58 <release>
    return -1;
    80001118:	597d                	li	s2,-1
    8000111a:	6a42                	ld	s4,16(sp)
    8000111c:	a0b5                	j	80001188 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000111e:	04a1                	addi	s1,s1,8
    80001120:	0921                	addi	s2,s2,8
    80001122:	01348963          	beq	s1,s3,80001134 <fork+0xa8>
    if(p->ofile[i])
    80001126:	6088                	ld	a0,0(s1)
    80001128:	d97d                	beqz	a0,8000111e <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000112a:	2c6020ef          	jal	800033f0 <filedup>
    8000112e:	00a93023          	sd	a0,0(s2)
    80001132:	b7f5                	j	8000111e <fork+0x92>
  np->cwd = idup(p->cwd);
    80001134:	150ab503          	ld	a0,336(s5)
    80001138:	580010ef          	jal	800026b8 <idup>
    8000113c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001140:	4641                	li	a2,16
    80001142:	158a8593          	addi	a1,s5,344
    80001146:	158a0513          	addi	a0,s4,344
    8000114a:	942ff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    8000114e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001152:	8552                	mv	a0,s4
    80001154:	105040ef          	jal	80005a58 <release>
  acquire(&wait_lock);
    80001158:	00009497          	auipc	s1,0x9
    8000115c:	1a048493          	addi	s1,s1,416 # 8000a2f8 <wait_lock>
    80001160:	8526                	mv	a0,s1
    80001162:	05f040ef          	jal	800059c0 <acquire>
  np->parent = p;
    80001166:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000116a:	8526                	mv	a0,s1
    8000116c:	0ed040ef          	jal	80005a58 <release>
  acquire(&np->lock);
    80001170:	8552                	mv	a0,s4
    80001172:	04f040ef          	jal	800059c0 <acquire>
  np->state = RUNNABLE;
    80001176:	478d                	li	a5,3
    80001178:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000117c:	8552                	mv	a0,s4
    8000117e:	0db040ef          	jal	80005a58 <release>
  return pid;
    80001182:	74a2                	ld	s1,40(sp)
    80001184:	69e2                	ld	s3,24(sp)
    80001186:	6a42                	ld	s4,16(sp)
}
    80001188:	854a                	mv	a0,s2
    8000118a:	70e2                	ld	ra,56(sp)
    8000118c:	7442                	ld	s0,48(sp)
    8000118e:	7902                	ld	s2,32(sp)
    80001190:	6aa2                	ld	s5,8(sp)
    80001192:	6121                	addi	sp,sp,64
    80001194:	8082                	ret
    return -1;
    80001196:	597d                	li	s2,-1
    80001198:	bfc5                	j	80001188 <fork+0xfc>

000000008000119a <scheduler>:
{
    8000119a:	715d                	addi	sp,sp,-80
    8000119c:	e486                	sd	ra,72(sp)
    8000119e:	e0a2                	sd	s0,64(sp)
    800011a0:	fc26                	sd	s1,56(sp)
    800011a2:	f84a                	sd	s2,48(sp)
    800011a4:	f44e                	sd	s3,40(sp)
    800011a6:	f052                	sd	s4,32(sp)
    800011a8:	ec56                	sd	s5,24(sp)
    800011aa:	e85a                	sd	s6,16(sp)
    800011ac:	e45e                	sd	s7,8(sp)
    800011ae:	e062                	sd	s8,0(sp)
    800011b0:	0880                	addi	s0,sp,80
    800011b2:	8792                	mv	a5,tp
  int id = r_tp();
    800011b4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011b6:	00779b93          	slli	s7,a5,0x7
    800011ba:	00009717          	auipc	a4,0x9
    800011be:	12670713          	addi	a4,a4,294 # 8000a2e0 <pid_lock>
    800011c2:	975e                	add	a4,a4,s7
    800011c4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c8:	00009717          	auipc	a4,0x9
    800011cc:	15070713          	addi	a4,a4,336 # 8000a318 <cpus+0x8>
    800011d0:	9bba                	add	s7,s7,a4
    int nproc = 0;
    800011d2:	4c01                	li	s8,0
      if(p->state == RUNNABLE) {
    800011d4:	4a0d                	li	s4,3
        c->proc = p;
    800011d6:	079e                	slli	a5,a5,0x7
    800011d8:	00009a97          	auipc	s5,0x9
    800011dc:	108a8a93          	addi	s5,s5,264 # 8000a2e0 <pid_lock>
    800011e0:	9abe                	add	s5,s5,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800011e2:	0000a997          	auipc	s3,0xa
    800011e6:	33e98993          	addi	s3,s3,830 # 8000b520 <tickslock>
    800011ea:	a0a9                	j	80001234 <scheduler+0x9a>
      release(&p->lock);
    800011ec:	8526                	mv	a0,s1
    800011ee:	06b040ef          	jal	80005a58 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011f2:	16848493          	addi	s1,s1,360
    800011f6:	03348663          	beq	s1,s3,80001222 <scheduler+0x88>
      acquire(&p->lock);
    800011fa:	8526                	mv	a0,s1
    800011fc:	7c4040ef          	jal	800059c0 <acquire>
      if(p->state != UNUSED) {
    80001200:	4c9c                	lw	a5,24(s1)
    80001202:	d7ed                	beqz	a5,800011ec <scheduler+0x52>
        nproc++;
    80001204:	2905                	addiw	s2,s2,1
      if(p->state == RUNNABLE) {
    80001206:	ff4793e3          	bne	a5,s4,800011ec <scheduler+0x52>
        p->state = RUNNING;
    8000120a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000120e:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    80001212:	06048593          	addi	a1,s1,96
    80001216:	855e                	mv	a0,s7
    80001218:	5aa000ef          	jal	800017c2 <swtch>
        c->proc = 0;
    8000121c:	020ab823          	sd	zero,48(s5)
    80001220:	b7f1                	j	800011ec <scheduler+0x52>
    if(nproc <= 2) {   // only init and sh exist
    80001222:	4789                	li	a5,2
    80001224:	0127c863          	blt	a5,s2,80001234 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001228:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000122c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001230:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001234:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001238:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000123c:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80001240:	8962                	mv	s2,s8
    for(p = proc; p < &proc[NPROC]; p++) {
    80001242:	00009497          	auipc	s1,0x9
    80001246:	4ce48493          	addi	s1,s1,1230 # 8000a710 <proc>
        p->state = RUNNING;
    8000124a:	4b11                	li	s6,4
    8000124c:	b77d                	j	800011fa <scheduler+0x60>

000000008000124e <sched>:
{
    8000124e:	7179                	addi	sp,sp,-48
    80001250:	f406                	sd	ra,40(sp)
    80001252:	f022                	sd	s0,32(sp)
    80001254:	ec26                	sd	s1,24(sp)
    80001256:	e84a                	sd	s2,16(sp)
    80001258:	e44e                	sd	s3,8(sp)
    8000125a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000125c:	b0bff0ef          	jal	80000d66 <myproc>
    80001260:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001262:	6f4040ef          	jal	80005956 <holding>
    80001266:	c92d                	beqz	a0,800012d8 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001268:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000126a:	2781                	sext.w	a5,a5
    8000126c:	079e                	slli	a5,a5,0x7
    8000126e:	00009717          	auipc	a4,0x9
    80001272:	07270713          	addi	a4,a4,114 # 8000a2e0 <pid_lock>
    80001276:	97ba                	add	a5,a5,a4
    80001278:	0a87a703          	lw	a4,168(a5)
    8000127c:	4785                	li	a5,1
    8000127e:	06f71363          	bne	a4,a5,800012e4 <sched+0x96>
  if(p->state == RUNNING)
    80001282:	4c98                	lw	a4,24(s1)
    80001284:	4791                	li	a5,4
    80001286:	06f70563          	beq	a4,a5,800012f0 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000128a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000128e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001290:	e7b5                	bnez	a5,800012fc <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001292:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001294:	00009917          	auipc	s2,0x9
    80001298:	04c90913          	addi	s2,s2,76 # 8000a2e0 <pid_lock>
    8000129c:	2781                	sext.w	a5,a5
    8000129e:	079e                	slli	a5,a5,0x7
    800012a0:	97ca                	add	a5,a5,s2
    800012a2:	0ac7a983          	lw	s3,172(a5)
    800012a6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012a8:	2781                	sext.w	a5,a5
    800012aa:	079e                	slli	a5,a5,0x7
    800012ac:	00009597          	auipc	a1,0x9
    800012b0:	06c58593          	addi	a1,a1,108 # 8000a318 <cpus+0x8>
    800012b4:	95be                	add	a1,a1,a5
    800012b6:	06048513          	addi	a0,s1,96
    800012ba:	508000ef          	jal	800017c2 <swtch>
    800012be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012c0:	2781                	sext.w	a5,a5
    800012c2:	079e                	slli	a5,a5,0x7
    800012c4:	993e                	add	s2,s2,a5
    800012c6:	0b392623          	sw	s3,172(s2)
}
    800012ca:	70a2                	ld	ra,40(sp)
    800012cc:	7402                	ld	s0,32(sp)
    800012ce:	64e2                	ld	s1,24(sp)
    800012d0:	6942                	ld	s2,16(sp)
    800012d2:	69a2                	ld	s3,8(sp)
    800012d4:	6145                	addi	sp,sp,48
    800012d6:	8082                	ret
    panic("sched p->lock");
    800012d8:	00006517          	auipc	a0,0x6
    800012dc:	f0050513          	addi	a0,a0,-256 # 800071d8 <etext+0x1d8>
    800012e0:	3b2040ef          	jal	80005692 <panic>
    panic("sched locks");
    800012e4:	00006517          	auipc	a0,0x6
    800012e8:	f0450513          	addi	a0,a0,-252 # 800071e8 <etext+0x1e8>
    800012ec:	3a6040ef          	jal	80005692 <panic>
    panic("sched running");
    800012f0:	00006517          	auipc	a0,0x6
    800012f4:	f0850513          	addi	a0,a0,-248 # 800071f8 <etext+0x1f8>
    800012f8:	39a040ef          	jal	80005692 <panic>
    panic("sched interruptible");
    800012fc:	00006517          	auipc	a0,0x6
    80001300:	f0c50513          	addi	a0,a0,-244 # 80007208 <etext+0x208>
    80001304:	38e040ef          	jal	80005692 <panic>

0000000080001308 <yield>:
{
    80001308:	1101                	addi	sp,sp,-32
    8000130a:	ec06                	sd	ra,24(sp)
    8000130c:	e822                	sd	s0,16(sp)
    8000130e:	e426                	sd	s1,8(sp)
    80001310:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001312:	a55ff0ef          	jal	80000d66 <myproc>
    80001316:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001318:	6a8040ef          	jal	800059c0 <acquire>
  p->state = RUNNABLE;
    8000131c:	478d                	li	a5,3
    8000131e:	cc9c                	sw	a5,24(s1)
  sched();
    80001320:	f2fff0ef          	jal	8000124e <sched>
  release(&p->lock);
    80001324:	8526                	mv	a0,s1
    80001326:	732040ef          	jal	80005a58 <release>
}
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6105                	addi	sp,sp,32
    80001332:	8082                	ret

0000000080001334 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001334:	7179                	addi	sp,sp,-48
    80001336:	f406                	sd	ra,40(sp)
    80001338:	f022                	sd	s0,32(sp)
    8000133a:	ec26                	sd	s1,24(sp)
    8000133c:	e84a                	sd	s2,16(sp)
    8000133e:	e44e                	sd	s3,8(sp)
    80001340:	1800                	addi	s0,sp,48
    80001342:	89aa                	mv	s3,a0
    80001344:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001346:	a21ff0ef          	jal	80000d66 <myproc>
    8000134a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000134c:	674040ef          	jal	800059c0 <acquire>
  release(lk);
    80001350:	854a                	mv	a0,s2
    80001352:	706040ef          	jal	80005a58 <release>

  // Go to sleep.
  p->chan = chan;
    80001356:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000135a:	4789                	li	a5,2
    8000135c:	cc9c                	sw	a5,24(s1)

  sched();
    8000135e:	ef1ff0ef          	jal	8000124e <sched>

  // Tidy up.
  p->chan = 0;
    80001362:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001366:	8526                	mv	a0,s1
    80001368:	6f0040ef          	jal	80005a58 <release>
  acquire(lk);
    8000136c:	854a                	mv	a0,s2
    8000136e:	652040ef          	jal	800059c0 <acquire>
}
    80001372:	70a2                	ld	ra,40(sp)
    80001374:	7402                	ld	s0,32(sp)
    80001376:	64e2                	ld	s1,24(sp)
    80001378:	6942                	ld	s2,16(sp)
    8000137a:	69a2                	ld	s3,8(sp)
    8000137c:	6145                	addi	sp,sp,48
    8000137e:	8082                	ret

0000000080001380 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001380:	7179                	addi	sp,sp,-48
    80001382:	f406                	sd	ra,40(sp)
    80001384:	f022                	sd	s0,32(sp)
    80001386:	ec26                	sd	s1,24(sp)
    80001388:	e84a                	sd	s2,16(sp)
    8000138a:	e44e                	sd	s3,8(sp)
    8000138c:	e052                	sd	s4,0(sp)
    8000138e:	1800                	addi	s0,sp,48
    80001390:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001392:	00009497          	auipc	s1,0x9
    80001396:	37e48493          	addi	s1,s1,894 # 8000a710 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000139a:	4989                	li	s3,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000139c:	0000a917          	auipc	s2,0xa
    800013a0:	18490913          	addi	s2,s2,388 # 8000b520 <tickslock>
    800013a4:	a801                	j	800013b4 <wakeup+0x34>
        p->state = RUNNABLE;
      }
      release(&p->lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	6b0040ef          	jal	80005a58 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	16848493          	addi	s1,s1,360
    800013b0:	03248263          	beq	s1,s2,800013d4 <wakeup+0x54>
    if(p != myproc()){
    800013b4:	9b3ff0ef          	jal	80000d66 <myproc>
    800013b8:	fea48ae3          	beq	s1,a0,800013ac <wakeup+0x2c>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	602040ef          	jal	800059c0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013c2:	4c9c                	lw	a5,24(s1)
    800013c4:	ff3791e3          	bne	a5,s3,800013a6 <wakeup+0x26>
    800013c8:	709c                	ld	a5,32(s1)
    800013ca:	fd479ee3          	bne	a5,s4,800013a6 <wakeup+0x26>
        p->state = RUNNABLE;
    800013ce:	478d                	li	a5,3
    800013d0:	cc9c                	sw	a5,24(s1)
    800013d2:	bfd1                	j	800013a6 <wakeup+0x26>
    }
  }
}
    800013d4:	70a2                	ld	ra,40(sp)
    800013d6:	7402                	ld	s0,32(sp)
    800013d8:	64e2                	ld	s1,24(sp)
    800013da:	6942                	ld	s2,16(sp)
    800013dc:	69a2                	ld	s3,8(sp)
    800013de:	6a02                	ld	s4,0(sp)
    800013e0:	6145                	addi	sp,sp,48
    800013e2:	8082                	ret

00000000800013e4 <reparent>:
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
    800013f4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013f6:	00009497          	auipc	s1,0x9
    800013fa:	31a48493          	addi	s1,s1,794 # 8000a710 <proc>
      pp->parent = initproc;
    800013fe:	00009a17          	auipc	s4,0x9
    80001402:	ea2a0a13          	addi	s4,s4,-350 # 8000a2a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001406:	0000a997          	auipc	s3,0xa
    8000140a:	11a98993          	addi	s3,s3,282 # 8000b520 <tickslock>
    8000140e:	a029                	j	80001418 <reparent+0x34>
    80001410:	16848493          	addi	s1,s1,360
    80001414:	01348b63          	beq	s1,s3,8000142a <reparent+0x46>
    if(pp->parent == p){
    80001418:	7c9c                	ld	a5,56(s1)
    8000141a:	ff279be3          	bne	a5,s2,80001410 <reparent+0x2c>
      pp->parent = initproc;
    8000141e:	000a3503          	ld	a0,0(s4)
    80001422:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001424:	f5dff0ef          	jal	80001380 <wakeup>
    80001428:	b7e5                	j	80001410 <reparent+0x2c>
}
    8000142a:	70a2                	ld	ra,40(sp)
    8000142c:	7402                	ld	s0,32(sp)
    8000142e:	64e2                	ld	s1,24(sp)
    80001430:	6942                	ld	s2,16(sp)
    80001432:	69a2                	ld	s3,8(sp)
    80001434:	6a02                	ld	s4,0(sp)
    80001436:	6145                	addi	sp,sp,48
    80001438:	8082                	ret

000000008000143a <exit>:
{
    8000143a:	7179                	addi	sp,sp,-48
    8000143c:	f406                	sd	ra,40(sp)
    8000143e:	f022                	sd	s0,32(sp)
    80001440:	ec26                	sd	s1,24(sp)
    80001442:	e84a                	sd	s2,16(sp)
    80001444:	e44e                	sd	s3,8(sp)
    80001446:	e052                	sd	s4,0(sp)
    80001448:	1800                	addi	s0,sp,48
    8000144a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000144c:	91bff0ef          	jal	80000d66 <myproc>
    80001450:	89aa                	mv	s3,a0
  if(p == initproc)
    80001452:	00009797          	auipc	a5,0x9
    80001456:	e4e7b783          	ld	a5,-434(a5) # 8000a2a0 <initproc>
    8000145a:	0d050493          	addi	s1,a0,208
    8000145e:	15050913          	addi	s2,a0,336
    80001462:	00a79f63          	bne	a5,a0,80001480 <exit+0x46>
    panic("init exiting");
    80001466:	00006517          	auipc	a0,0x6
    8000146a:	dba50513          	addi	a0,a0,-582 # 80007220 <etext+0x220>
    8000146e:	224040ef          	jal	80005692 <panic>
      fileclose(f);
    80001472:	7c5010ef          	jal	80003436 <fileclose>
      p->ofile[fd] = 0;
    80001476:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000147a:	04a1                	addi	s1,s1,8
    8000147c:	01248563          	beq	s1,s2,80001486 <exit+0x4c>
    if(p->ofile[fd]){
    80001480:	6088                	ld	a0,0(s1)
    80001482:	f965                	bnez	a0,80001472 <exit+0x38>
    80001484:	bfdd                	j	8000147a <exit+0x40>
  begin_op();
    80001486:	397010ef          	jal	8000301c <begin_op>
  iput(p->cwd);
    8000148a:	1509b503          	ld	a0,336(s3)
    8000148e:	478010ef          	jal	80002906 <iput>
  end_op();
    80001492:	3f5010ef          	jal	80003086 <end_op>
  p->cwd = 0;
    80001496:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000149a:	00009497          	auipc	s1,0x9
    8000149e:	e5e48493          	addi	s1,s1,-418 # 8000a2f8 <wait_lock>
    800014a2:	8526                	mv	a0,s1
    800014a4:	51c040ef          	jal	800059c0 <acquire>
  reparent(p);
    800014a8:	854e                	mv	a0,s3
    800014aa:	f3bff0ef          	jal	800013e4 <reparent>
  wakeup(p->parent);
    800014ae:	0389b503          	ld	a0,56(s3)
    800014b2:	ecfff0ef          	jal	80001380 <wakeup>
  acquire(&p->lock);
    800014b6:	854e                	mv	a0,s3
    800014b8:	508040ef          	jal	800059c0 <acquire>
  p->xstate = status;
    800014bc:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c0:	4795                	li	a5,5
    800014c2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014c6:	8526                	mv	a0,s1
    800014c8:	590040ef          	jal	80005a58 <release>
  sched();
    800014cc:	d83ff0ef          	jal	8000124e <sched>
  panic("zombie exit");
    800014d0:	00006517          	auipc	a0,0x6
    800014d4:	d6050513          	addi	a0,a0,-672 # 80007230 <etext+0x230>
    800014d8:	1ba040ef          	jal	80005692 <panic>

00000000800014dc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014dc:	7179                	addi	sp,sp,-48
    800014de:	f406                	sd	ra,40(sp)
    800014e0:	f022                	sd	s0,32(sp)
    800014e2:	ec26                	sd	s1,24(sp)
    800014e4:	e84a                	sd	s2,16(sp)
    800014e6:	e44e                	sd	s3,8(sp)
    800014e8:	1800                	addi	s0,sp,48
    800014ea:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014ec:	00009497          	auipc	s1,0x9
    800014f0:	22448493          	addi	s1,s1,548 # 8000a710 <proc>
    800014f4:	0000a997          	auipc	s3,0xa
    800014f8:	02c98993          	addi	s3,s3,44 # 8000b520 <tickslock>
    acquire(&p->lock);
    800014fc:	8526                	mv	a0,s1
    800014fe:	4c2040ef          	jal	800059c0 <acquire>
    if(p->pid == pid){
    80001502:	589c                	lw	a5,48(s1)
    80001504:	03278163          	beq	a5,s2,80001526 <kill+0x4a>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001508:	8526                	mv	a0,s1
    8000150a:	54e040ef          	jal	80005a58 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000150e:	16848493          	addi	s1,s1,360
    80001512:	ff3495e3          	bne	s1,s3,800014fc <kill+0x20>
  }
  return -1;
    80001516:	557d                	li	a0,-1
}
    80001518:	70a2                	ld	ra,40(sp)
    8000151a:	7402                	ld	s0,32(sp)
    8000151c:	64e2                	ld	s1,24(sp)
    8000151e:	6942                	ld	s2,16(sp)
    80001520:	69a2                	ld	s3,8(sp)
    80001522:	6145                	addi	sp,sp,48
    80001524:	8082                	ret
      p->killed = 1;
    80001526:	4785                	li	a5,1
    80001528:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000152a:	4c98                	lw	a4,24(s1)
    8000152c:	4789                	li	a5,2
    8000152e:	00f70763          	beq	a4,a5,8000153c <kill+0x60>
      release(&p->lock);
    80001532:	8526                	mv	a0,s1
    80001534:	524040ef          	jal	80005a58 <release>
      return 0;
    80001538:	4501                	li	a0,0
    8000153a:	bff9                	j	80001518 <kill+0x3c>
        p->state = RUNNABLE;
    8000153c:	478d                	li	a5,3
    8000153e:	cc9c                	sw	a5,24(s1)
    80001540:	bfcd                	j	80001532 <kill+0x56>

0000000080001542 <setkilled>:

void
setkilled(struct proc *p)
{
    80001542:	1101                	addi	sp,sp,-32
    80001544:	ec06                	sd	ra,24(sp)
    80001546:	e822                	sd	s0,16(sp)
    80001548:	e426                	sd	s1,8(sp)
    8000154a:	1000                	addi	s0,sp,32
    8000154c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000154e:	472040ef          	jal	800059c0 <acquire>
  p->killed = 1;
    80001552:	4785                	li	a5,1
    80001554:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001556:	8526                	mv	a0,s1
    80001558:	500040ef          	jal	80005a58 <release>
}
    8000155c:	60e2                	ld	ra,24(sp)
    8000155e:	6442                	ld	s0,16(sp)
    80001560:	64a2                	ld	s1,8(sp)
    80001562:	6105                	addi	sp,sp,32
    80001564:	8082                	ret

0000000080001566 <killed>:

int
killed(struct proc *p)
{
    80001566:	1101                	addi	sp,sp,-32
    80001568:	ec06                	sd	ra,24(sp)
    8000156a:	e822                	sd	s0,16(sp)
    8000156c:	e426                	sd	s1,8(sp)
    8000156e:	e04a                	sd	s2,0(sp)
    80001570:	1000                	addi	s0,sp,32
    80001572:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001574:	44c040ef          	jal	800059c0 <acquire>
  k = p->killed;
    80001578:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000157c:	8526                	mv	a0,s1
    8000157e:	4da040ef          	jal	80005a58 <release>
  return k;
}
    80001582:	854a                	mv	a0,s2
    80001584:	60e2                	ld	ra,24(sp)
    80001586:	6442                	ld	s0,16(sp)
    80001588:	64a2                	ld	s1,8(sp)
    8000158a:	6902                	ld	s2,0(sp)
    8000158c:	6105                	addi	sp,sp,32
    8000158e:	8082                	ret

0000000080001590 <wait>:
{
    80001590:	715d                	addi	sp,sp,-80
    80001592:	e486                	sd	ra,72(sp)
    80001594:	e0a2                	sd	s0,64(sp)
    80001596:	fc26                	sd	s1,56(sp)
    80001598:	f84a                	sd	s2,48(sp)
    8000159a:	f44e                	sd	s3,40(sp)
    8000159c:	f052                	sd	s4,32(sp)
    8000159e:	ec56                	sd	s5,24(sp)
    800015a0:	e85a                	sd	s6,16(sp)
    800015a2:	e45e                	sd	s7,8(sp)
    800015a4:	e062                	sd	s8,0(sp)
    800015a6:	0880                	addi	s0,sp,80
    800015a8:	8c2a                	mv	s8,a0
  struct proc *p = myproc();
    800015aa:	fbcff0ef          	jal	80000d66 <myproc>
    800015ae:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015b0:	00009517          	auipc	a0,0x9
    800015b4:	d4850513          	addi	a0,a0,-696 # 8000a2f8 <wait_lock>
    800015b8:	408040ef          	jal	800059c0 <acquire>
    havekids = 0;
    800015bc:	4b01                	li	s6,0
        if(pp->state == ZOMBIE){
    800015be:	4a15                	li	s4,5
        havekids = 1;
    800015c0:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c2:	0000a997          	auipc	s3,0xa
    800015c6:	f5e98993          	addi	s3,s3,-162 # 8000b520 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015ca:	00009b97          	auipc	s7,0x9
    800015ce:	d2eb8b93          	addi	s7,s7,-722 # 8000a2f8 <wait_lock>
    800015d2:	a871                	j	8000166e <wait+0xde>
          pid = pp->pid;
    800015d4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015d8:	000c0c63          	beqz	s8,800015f0 <wait+0x60>
    800015dc:	4691                	li	a3,4
    800015de:	02c48613          	addi	a2,s1,44
    800015e2:	85e2                	mv	a1,s8
    800015e4:	05093503          	ld	a0,80(s2)
    800015e8:	bf0ff0ef          	jal	800009d8 <copyout>
    800015ec:	02054b63          	bltz	a0,80001622 <wait+0x92>
          freeproc(pp);
    800015f0:	8526                	mv	a0,s1
    800015f2:	8e7ff0ef          	jal	80000ed8 <freeproc>
          release(&pp->lock);
    800015f6:	8526                	mv	a0,s1
    800015f8:	460040ef          	jal	80005a58 <release>
          release(&wait_lock);
    800015fc:	00009517          	auipc	a0,0x9
    80001600:	cfc50513          	addi	a0,a0,-772 # 8000a2f8 <wait_lock>
    80001604:	454040ef          	jal	80005a58 <release>
}
    80001608:	854e                	mv	a0,s3
    8000160a:	60a6                	ld	ra,72(sp)
    8000160c:	6406                	ld	s0,64(sp)
    8000160e:	74e2                	ld	s1,56(sp)
    80001610:	7942                	ld	s2,48(sp)
    80001612:	79a2                	ld	s3,40(sp)
    80001614:	7a02                	ld	s4,32(sp)
    80001616:	6ae2                	ld	s5,24(sp)
    80001618:	6b42                	ld	s6,16(sp)
    8000161a:	6ba2                	ld	s7,8(sp)
    8000161c:	6c02                	ld	s8,0(sp)
    8000161e:	6161                	addi	sp,sp,80
    80001620:	8082                	ret
            release(&pp->lock);
    80001622:	8526                	mv	a0,s1
    80001624:	434040ef          	jal	80005a58 <release>
            release(&wait_lock);
    80001628:	00009517          	auipc	a0,0x9
    8000162c:	cd050513          	addi	a0,a0,-816 # 8000a2f8 <wait_lock>
    80001630:	428040ef          	jal	80005a58 <release>
            return -1;
    80001634:	59fd                	li	s3,-1
    80001636:	bfc9                	j	80001608 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001638:	16848493          	addi	s1,s1,360
    8000163c:	03348063          	beq	s1,s3,8000165c <wait+0xcc>
      if(pp->parent == p){
    80001640:	7c9c                	ld	a5,56(s1)
    80001642:	ff279be3          	bne	a5,s2,80001638 <wait+0xa8>
        acquire(&pp->lock);
    80001646:	8526                	mv	a0,s1
    80001648:	378040ef          	jal	800059c0 <acquire>
        if(pp->state == ZOMBIE){
    8000164c:	4c9c                	lw	a5,24(s1)
    8000164e:	f94783e3          	beq	a5,s4,800015d4 <wait+0x44>
        release(&pp->lock);
    80001652:	8526                	mv	a0,s1
    80001654:	404040ef          	jal	80005a58 <release>
        havekids = 1;
    80001658:	8756                	mv	a4,s5
    8000165a:	bff9                	j	80001638 <wait+0xa8>
    if(!havekids || killed(p)){
    8000165c:	cf19                	beqz	a4,8000167a <wait+0xea>
    8000165e:	854a                	mv	a0,s2
    80001660:	f07ff0ef          	jal	80001566 <killed>
    80001664:	e919                	bnez	a0,8000167a <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001666:	85de                	mv	a1,s7
    80001668:	854a                	mv	a0,s2
    8000166a:	ccbff0ef          	jal	80001334 <sleep>
    havekids = 0;
    8000166e:	875a                	mv	a4,s6
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001670:	00009497          	auipc	s1,0x9
    80001674:	0a048493          	addi	s1,s1,160 # 8000a710 <proc>
    80001678:	b7e1                	j	80001640 <wait+0xb0>
      release(&wait_lock);
    8000167a:	00009517          	auipc	a0,0x9
    8000167e:	c7e50513          	addi	a0,a0,-898 # 8000a2f8 <wait_lock>
    80001682:	3d6040ef          	jal	80005a58 <release>
      return -1;
    80001686:	59fd                	li	s3,-1
    80001688:	b741                	j	80001608 <wait+0x78>

000000008000168a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000168a:	7179                	addi	sp,sp,-48
    8000168c:	f406                	sd	ra,40(sp)
    8000168e:	f022                	sd	s0,32(sp)
    80001690:	ec26                	sd	s1,24(sp)
    80001692:	e84a                	sd	s2,16(sp)
    80001694:	e44e                	sd	s3,8(sp)
    80001696:	e052                	sd	s4,0(sp)
    80001698:	1800                	addi	s0,sp,48
    8000169a:	84aa                	mv	s1,a0
    8000169c:	892e                	mv	s2,a1
    8000169e:	89b2                	mv	s3,a2
    800016a0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016a2:	ec4ff0ef          	jal	80000d66 <myproc>
  if(user_dst){
    800016a6:	cc99                	beqz	s1,800016c4 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016a8:	86d2                	mv	a3,s4
    800016aa:	864e                	mv	a2,s3
    800016ac:	85ca                	mv	a1,s2
    800016ae:	6928                	ld	a0,80(a0)
    800016b0:	b28ff0ef          	jal	800009d8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016b4:	70a2                	ld	ra,40(sp)
    800016b6:	7402                	ld	s0,32(sp)
    800016b8:	64e2                	ld	s1,24(sp)
    800016ba:	6942                	ld	s2,16(sp)
    800016bc:	69a2                	ld	s3,8(sp)
    800016be:	6a02                	ld	s4,0(sp)
    800016c0:	6145                	addi	sp,sp,48
    800016c2:	8082                	ret
    memmove((char *)dst, src, len);
    800016c4:	000a061b          	sext.w	a2,s4
    800016c8:	85ce                	mv	a1,s3
    800016ca:	854a                	mv	a0,s2
    800016cc:	adffe0ef          	jal	800001aa <memmove>
    return 0;
    800016d0:	8526                	mv	a0,s1
    800016d2:	b7cd                	j	800016b4 <either_copyout+0x2a>

00000000800016d4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016d4:	7179                	addi	sp,sp,-48
    800016d6:	f406                	sd	ra,40(sp)
    800016d8:	f022                	sd	s0,32(sp)
    800016da:	ec26                	sd	s1,24(sp)
    800016dc:	e84a                	sd	s2,16(sp)
    800016de:	e44e                	sd	s3,8(sp)
    800016e0:	e052                	sd	s4,0(sp)
    800016e2:	1800                	addi	s0,sp,48
    800016e4:	892a                	mv	s2,a0
    800016e6:	84ae                	mv	s1,a1
    800016e8:	89b2                	mv	s3,a2
    800016ea:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016ec:	e7aff0ef          	jal	80000d66 <myproc>
  if(user_src){
    800016f0:	cc99                	beqz	s1,8000170e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016f2:	86d2                	mv	a3,s4
    800016f4:	864e                	mv	a2,s3
    800016f6:	85ca                	mv	a1,s2
    800016f8:	6928                	ld	a0,80(a0)
    800016fa:	bb4ff0ef          	jal	80000aae <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016fe:	70a2                	ld	ra,40(sp)
    80001700:	7402                	ld	s0,32(sp)
    80001702:	64e2                	ld	s1,24(sp)
    80001704:	6942                	ld	s2,16(sp)
    80001706:	69a2                	ld	s3,8(sp)
    80001708:	6a02                	ld	s4,0(sp)
    8000170a:	6145                	addi	sp,sp,48
    8000170c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000170e:	000a061b          	sext.w	a2,s4
    80001712:	85ce                	mv	a1,s3
    80001714:	854a                	mv	a0,s2
    80001716:	a95fe0ef          	jal	800001aa <memmove>
    return 0;
    8000171a:	8526                	mv	a0,s1
    8000171c:	b7cd                	j	800016fe <either_copyin+0x2a>

000000008000171e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000171e:	715d                	addi	sp,sp,-80
    80001720:	e486                	sd	ra,72(sp)
    80001722:	e0a2                	sd	s0,64(sp)
    80001724:	fc26                	sd	s1,56(sp)
    80001726:	f84a                	sd	s2,48(sp)
    80001728:	f44e                	sd	s3,40(sp)
    8000172a:	f052                	sd	s4,32(sp)
    8000172c:	ec56                	sd	s5,24(sp)
    8000172e:	e85a                	sd	s6,16(sp)
    80001730:	e45e                	sd	s7,8(sp)
    80001732:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001734:	00006517          	auipc	a0,0x6
    80001738:	8e450513          	addi	a0,a0,-1820 # 80007018 <etext+0x18>
    8000173c:	485030ef          	jal	800053c0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001740:	00009497          	auipc	s1,0x9
    80001744:	12848493          	addi	s1,s1,296 # 8000a868 <proc+0x158>
    80001748:	0000a917          	auipc	s2,0xa
    8000174c:	f3090913          	addi	s2,s2,-208 # 8000b678 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001750:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001752:	00006997          	auipc	s3,0x6
    80001756:	aee98993          	addi	s3,s3,-1298 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    8000175a:	00006a97          	auipc	s5,0x6
    8000175e:	aeea8a93          	addi	s5,s5,-1298 # 80007248 <etext+0x248>
    printf("\n");
    80001762:	00006a17          	auipc	s4,0x6
    80001766:	8b6a0a13          	addi	s4,s4,-1866 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000176a:	00006b97          	auipc	s7,0x6
    8000176e:	006b8b93          	addi	s7,s7,6 # 80007770 <states.0>
    80001772:	a829                	j	8000178c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001774:	ed86a583          	lw	a1,-296(a3)
    80001778:	8556                	mv	a0,s5
    8000177a:	447030ef          	jal	800053c0 <printf>
    printf("\n");
    8000177e:	8552                	mv	a0,s4
    80001780:	441030ef          	jal	800053c0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001784:	16848493          	addi	s1,s1,360
    80001788:	03248263          	beq	s1,s2,800017ac <procdump+0x8e>
    if(p->state == UNUSED)
    8000178c:	86a6                	mv	a3,s1
    8000178e:	ec04a783          	lw	a5,-320(s1)
    80001792:	dbed                	beqz	a5,80001784 <procdump+0x66>
      state = "???";
    80001794:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001796:	fcfb6fe3          	bltu	s6,a5,80001774 <procdump+0x56>
    8000179a:	02079713          	slli	a4,a5,0x20
    8000179e:	01d75793          	srli	a5,a4,0x1d
    800017a2:	97de                	add	a5,a5,s7
    800017a4:	6390                	ld	a2,0(a5)
    800017a6:	f679                	bnez	a2,80001774 <procdump+0x56>
      state = "???";
    800017a8:	864e                	mv	a2,s3
    800017aa:	b7e9                	j	80001774 <procdump+0x56>
  }
}
    800017ac:	60a6                	ld	ra,72(sp)
    800017ae:	6406                	ld	s0,64(sp)
    800017b0:	74e2                	ld	s1,56(sp)
    800017b2:	7942                	ld	s2,48(sp)
    800017b4:	79a2                	ld	s3,40(sp)
    800017b6:	7a02                	ld	s4,32(sp)
    800017b8:	6ae2                	ld	s5,24(sp)
    800017ba:	6b42                	ld	s6,16(sp)
    800017bc:	6ba2                	ld	s7,8(sp)
    800017be:	6161                	addi	sp,sp,80
    800017c0:	8082                	ret

00000000800017c2 <swtch>:
    800017c2:	00153023          	sd	ra,0(a0)
    800017c6:	00253423          	sd	sp,8(a0)
    800017ca:	e900                	sd	s0,16(a0)
    800017cc:	ed04                	sd	s1,24(a0)
    800017ce:	03253023          	sd	s2,32(a0)
    800017d2:	03353423          	sd	s3,40(a0)
    800017d6:	03453823          	sd	s4,48(a0)
    800017da:	03553c23          	sd	s5,56(a0)
    800017de:	05653023          	sd	s6,64(a0)
    800017e2:	05753423          	sd	s7,72(a0)
    800017e6:	05853823          	sd	s8,80(a0)
    800017ea:	05953c23          	sd	s9,88(a0)
    800017ee:	07a53023          	sd	s10,96(a0)
    800017f2:	07b53423          	sd	s11,104(a0)
    800017f6:	0005b083          	ld	ra,0(a1)
    800017fa:	0085b103          	ld	sp,8(a1)
    800017fe:	6980                	ld	s0,16(a1)
    80001800:	6d84                	ld	s1,24(a1)
    80001802:	0205b903          	ld	s2,32(a1)
    80001806:	0285b983          	ld	s3,40(a1)
    8000180a:	0305ba03          	ld	s4,48(a1)
    8000180e:	0385ba83          	ld	s5,56(a1)
    80001812:	0405bb03          	ld	s6,64(a1)
    80001816:	0485bb83          	ld	s7,72(a1)
    8000181a:	0505bc03          	ld	s8,80(a1)
    8000181e:	0585bc83          	ld	s9,88(a1)
    80001822:	0605bd03          	ld	s10,96(a1)
    80001826:	0685bd83          	ld	s11,104(a1)
    8000182a:	8082                	ret

000000008000182c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000182c:	1141                	addi	sp,sp,-16
    8000182e:	e406                	sd	ra,8(sp)
    80001830:	e022                	sd	s0,0(sp)
    80001832:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001834:	00006597          	auipc	a1,0x6
    80001838:	a5458593          	addi	a1,a1,-1452 # 80007288 <etext+0x288>
    8000183c:	0000a517          	auipc	a0,0xa
    80001840:	ce450513          	addi	a0,a0,-796 # 8000b520 <tickslock>
    80001844:	0fc040ef          	jal	80005940 <initlock>
}
    80001848:	60a2                	ld	ra,8(sp)
    8000184a:	6402                	ld	s0,0(sp)
    8000184c:	0141                	addi	sp,sp,16
    8000184e:	8082                	ret

0000000080001850 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001850:	1141                	addi	sp,sp,-16
    80001852:	e422                	sd	s0,8(sp)
    80001854:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001856:	00003797          	auipc	a5,0x3
    8000185a:	0aa78793          	addi	a5,a5,170 # 80004900 <kernelvec>
    8000185e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001862:	6422                	ld	s0,8(sp)
    80001864:	0141                	addi	sp,sp,16
    80001866:	8082                	ret

0000000080001868 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001868:	1141                	addi	sp,sp,-16
    8000186a:	e406                	sd	ra,8(sp)
    8000186c:	e022                	sd	s0,0(sp)
    8000186e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001870:	cf6ff0ef          	jal	80000d66 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001874:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001878:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000187a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000187e:	00004697          	auipc	a3,0x4
    80001882:	78268693          	addi	a3,a3,1922 # 80006000 <_trampoline>
    80001886:	00004717          	auipc	a4,0x4
    8000188a:	77a70713          	addi	a4,a4,1914 # 80006000 <_trampoline>
    8000188e:	8f15                	sub	a4,a4,a3
    80001890:	040007b7          	lui	a5,0x4000
    80001894:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001896:	07b2                	slli	a5,a5,0xc
    80001898:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000189a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000189e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018a0:	18002673          	csrr	a2,satp
    800018a4:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018a6:	6d30                	ld	a2,88(a0)
    800018a8:	6138                	ld	a4,64(a0)
    800018aa:	6585                	lui	a1,0x1
    800018ac:	972e                	add	a4,a4,a1
    800018ae:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018b0:	6d38                	ld	a4,88(a0)
    800018b2:	00000617          	auipc	a2,0x0
    800018b6:	11060613          	addi	a2,a2,272 # 800019c2 <usertrap>
    800018ba:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018bc:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018be:	8612                	mv	a2,tp
    800018c0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018c2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018c6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018ca:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018ce:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018d2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018d4:	6f18                	ld	a4,24(a4)
    800018d6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018da:	6928                	ld	a0,80(a0)
    800018dc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018de:	00004717          	auipc	a4,0x4
    800018e2:	7be70713          	addi	a4,a4,1982 # 8000609c <userret>
    800018e6:	8f15                	sub	a4,a4,a3
    800018e8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018ea:	577d                	li	a4,-1
    800018ec:	177e                	slli	a4,a4,0x3f
    800018ee:	8d59                	or	a0,a0,a4
    800018f0:	9782                	jalr	a5
}
    800018f2:	60a2                	ld	ra,8(sp)
    800018f4:	6402                	ld	s0,0(sp)
    800018f6:	0141                	addi	sp,sp,16
    800018f8:	8082                	ret

00000000800018fa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018fa:	1101                	addi	sp,sp,-32
    800018fc:	ec06                	sd	ra,24(sp)
    800018fe:	e822                	sd	s0,16(sp)
    80001900:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001902:	c38ff0ef          	jal	80000d3a <cpuid>
    80001906:	cd11                	beqz	a0,80001922 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001908:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000190c:	000f4737          	lui	a4,0xf4
    80001910:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001914:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001916:	14d79073          	csrw	stimecmp,a5
}
    8000191a:	60e2                	ld	ra,24(sp)
    8000191c:	6442                	ld	s0,16(sp)
    8000191e:	6105                	addi	sp,sp,32
    80001920:	8082                	ret
    80001922:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001924:	0000a497          	auipc	s1,0xa
    80001928:	bfc48493          	addi	s1,s1,-1028 # 8000b520 <tickslock>
    8000192c:	8526                	mv	a0,s1
    8000192e:	092040ef          	jal	800059c0 <acquire>
    ticks++;
    80001932:	00009517          	auipc	a0,0x9
    80001936:	97650513          	addi	a0,a0,-1674 # 8000a2a8 <ticks>
    8000193a:	411c                	lw	a5,0(a0)
    8000193c:	2785                	addiw	a5,a5,1
    8000193e:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001940:	a41ff0ef          	jal	80001380 <wakeup>
    release(&tickslock);
    80001944:	8526                	mv	a0,s1
    80001946:	112040ef          	jal	80005a58 <release>
    8000194a:	64a2                	ld	s1,8(sp)
    8000194c:	bf75                	j	80001908 <clockintr+0xe>

000000008000194e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000194e:	1101                	addi	sp,sp,-32
    80001950:	ec06                	sd	ra,24(sp)
    80001952:	e822                	sd	s0,16(sp)
    80001954:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001956:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000195a:	57fd                	li	a5,-1
    8000195c:	17fe                	slli	a5,a5,0x3f
    8000195e:	07a5                	addi	a5,a5,9
    80001960:	00f70c63          	beq	a4,a5,80001978 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001964:	57fd                	li	a5,-1
    80001966:	17fe                	slli	a5,a5,0x3f
    80001968:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000196a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000196c:	04f70763          	beq	a4,a5,800019ba <devintr+0x6c>
  }
}
    80001970:	60e2                	ld	ra,24(sp)
    80001972:	6442                	ld	s0,16(sp)
    80001974:	6105                	addi	sp,sp,32
    80001976:	8082                	ret
    80001978:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000197a:	032030ef          	jal	800049ac <plic_claim>
    8000197e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001980:	47a9                	li	a5,10
    80001982:	00f50963          	beq	a0,a5,80001994 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001986:	4785                	li	a5,1
    80001988:	00f50963          	beq	a0,a5,8000199a <devintr+0x4c>
    return 1;
    8000198c:	4505                	li	a0,1
    } else if(irq){
    8000198e:	e889                	bnez	s1,800019a0 <devintr+0x52>
    80001990:	64a2                	ld	s1,8(sp)
    80001992:	bff9                	j	80001970 <devintr+0x22>
      uartintr();
    80001994:	771030ef          	jal	80005904 <uartintr>
    if(irq)
    80001998:	a819                	j	800019ae <devintr+0x60>
      virtio_disk_intr();
    8000199a:	4d8030ef          	jal	80004e72 <virtio_disk_intr>
    if(irq)
    8000199e:	a801                	j	800019ae <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019a0:	85a6                	mv	a1,s1
    800019a2:	00006517          	auipc	a0,0x6
    800019a6:	8ee50513          	addi	a0,a0,-1810 # 80007290 <etext+0x290>
    800019aa:	217030ef          	jal	800053c0 <printf>
      plic_complete(irq);
    800019ae:	8526                	mv	a0,s1
    800019b0:	01c030ef          	jal	800049cc <plic_complete>
    return 1;
    800019b4:	4505                	li	a0,1
    800019b6:	64a2                	ld	s1,8(sp)
    800019b8:	bf65                	j	80001970 <devintr+0x22>
    clockintr();
    800019ba:	f41ff0ef          	jal	800018fa <clockintr>
    return 2;
    800019be:	4509                	li	a0,2
    800019c0:	bf45                	j	80001970 <devintr+0x22>

00000000800019c2 <usertrap>:
{
    800019c2:	1101                	addi	sp,sp,-32
    800019c4:	ec06                	sd	ra,24(sp)
    800019c6:	e822                	sd	s0,16(sp)
    800019c8:	e426                	sd	s1,8(sp)
    800019ca:	e04a                	sd	s2,0(sp)
    800019cc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019ce:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019d2:	1007f793          	andi	a5,a5,256
    800019d6:	ef85                	bnez	a5,80001a0e <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019d8:	00003797          	auipc	a5,0x3
    800019dc:	f2878793          	addi	a5,a5,-216 # 80004900 <kernelvec>
    800019e0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019e4:	b82ff0ef          	jal	80000d66 <myproc>
    800019e8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019ea:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019ec:	14102773          	csrr	a4,sepc
    800019f0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019f2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019f6:	47a1                	li	a5,8
    800019f8:	02f70163          	beq	a4,a5,80001a1a <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019fc:	f53ff0ef          	jal	8000194e <devintr>
    80001a00:	892a                	mv	s2,a0
    80001a02:	c135                	beqz	a0,80001a66 <usertrap+0xa4>
  if(killed(p))
    80001a04:	8526                	mv	a0,s1
    80001a06:	b61ff0ef          	jal	80001566 <killed>
    80001a0a:	cd1d                	beqz	a0,80001a48 <usertrap+0x86>
    80001a0c:	a81d                	j	80001a42 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a0e:	00006517          	auipc	a0,0x6
    80001a12:	8a250513          	addi	a0,a0,-1886 # 800072b0 <etext+0x2b0>
    80001a16:	47d030ef          	jal	80005692 <panic>
    if(killed(p))
    80001a1a:	b4dff0ef          	jal	80001566 <killed>
    80001a1e:	e121                	bnez	a0,80001a5e <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a20:	6cb8                	ld	a4,88(s1)
    80001a22:	6f1c                	ld	a5,24(a4)
    80001a24:	0791                	addi	a5,a5,4
    80001a26:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a28:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a2c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a30:	10079073          	csrw	sstatus,a5
    syscall();
    80001a34:	248000ef          	jal	80001c7c <syscall>
  if(killed(p))
    80001a38:	8526                	mv	a0,s1
    80001a3a:	b2dff0ef          	jal	80001566 <killed>
    80001a3e:	c901                	beqz	a0,80001a4e <usertrap+0x8c>
    80001a40:	4901                	li	s2,0
    exit(-1);
    80001a42:	557d                	li	a0,-1
    80001a44:	9f7ff0ef          	jal	8000143a <exit>
  if(which_dev == 2)
    80001a48:	4789                	li	a5,2
    80001a4a:	04f90563          	beq	s2,a5,80001a94 <usertrap+0xd2>
  usertrapret();
    80001a4e:	e1bff0ef          	jal	80001868 <usertrapret>
}
    80001a52:	60e2                	ld	ra,24(sp)
    80001a54:	6442                	ld	s0,16(sp)
    80001a56:	64a2                	ld	s1,8(sp)
    80001a58:	6902                	ld	s2,0(sp)
    80001a5a:	6105                	addi	sp,sp,32
    80001a5c:	8082                	ret
      exit(-1);
    80001a5e:	557d                	li	a0,-1
    80001a60:	9dbff0ef          	jal	8000143a <exit>
    80001a64:	bf75                	j	80001a20 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a66:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a6a:	5890                	lw	a2,48(s1)
    80001a6c:	00006517          	auipc	a0,0x6
    80001a70:	86450513          	addi	a0,a0,-1948 # 800072d0 <etext+0x2d0>
    80001a74:	14d030ef          	jal	800053c0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a78:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a7c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a80:	00006517          	auipc	a0,0x6
    80001a84:	88050513          	addi	a0,a0,-1920 # 80007300 <etext+0x300>
    80001a88:	139030ef          	jal	800053c0 <printf>
    setkilled(p);
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	ab5ff0ef          	jal	80001542 <setkilled>
    80001a92:	b75d                	j	80001a38 <usertrap+0x76>
    yield();
    80001a94:	875ff0ef          	jal	80001308 <yield>
    80001a98:	bf5d                	j	80001a4e <usertrap+0x8c>

0000000080001a9a <kerneltrap>:
{
    80001a9a:	7179                	addi	sp,sp,-48
    80001a9c:	f406                	sd	ra,40(sp)
    80001a9e:	f022                	sd	s0,32(sp)
    80001aa0:	ec26                	sd	s1,24(sp)
    80001aa2:	e84a                	sd	s2,16(sp)
    80001aa4:	e44e                	sd	s3,8(sp)
    80001aa6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aa8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ab0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ab4:	1004f793          	andi	a5,s1,256
    80001ab8:	c795                	beqz	a5,80001ae4 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001abe:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ac0:	eb85                	bnez	a5,80001af0 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001ac2:	e8dff0ef          	jal	8000194e <devintr>
    80001ac6:	c91d                	beqz	a0,80001afc <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001ac8:	4789                	li	a5,2
    80001aca:	04f50a63          	beq	a0,a5,80001b1e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ace:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad2:	10049073          	csrw	sstatus,s1
}
    80001ad6:	70a2                	ld	ra,40(sp)
    80001ad8:	7402                	ld	s0,32(sp)
    80001ada:	64e2                	ld	s1,24(sp)
    80001adc:	6942                	ld	s2,16(sp)
    80001ade:	69a2                	ld	s3,8(sp)
    80001ae0:	6145                	addi	sp,sp,48
    80001ae2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ae4:	00006517          	auipc	a0,0x6
    80001ae8:	84450513          	addi	a0,a0,-1980 # 80007328 <etext+0x328>
    80001aec:	3a7030ef          	jal	80005692 <panic>
    panic("kerneltrap: interrupts enabled");
    80001af0:	00006517          	auipc	a0,0x6
    80001af4:	86050513          	addi	a0,a0,-1952 # 80007350 <etext+0x350>
    80001af8:	39b030ef          	jal	80005692 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001afc:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b00:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b04:	85ce                	mv	a1,s3
    80001b06:	00006517          	auipc	a0,0x6
    80001b0a:	86a50513          	addi	a0,a0,-1942 # 80007370 <etext+0x370>
    80001b0e:	0b3030ef          	jal	800053c0 <printf>
    panic("kerneltrap");
    80001b12:	00006517          	auipc	a0,0x6
    80001b16:	88650513          	addi	a0,a0,-1914 # 80007398 <etext+0x398>
    80001b1a:	379030ef          	jal	80005692 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b1e:	a48ff0ef          	jal	80000d66 <myproc>
    80001b22:	d555                	beqz	a0,80001ace <kerneltrap+0x34>
    yield();
    80001b24:	fe4ff0ef          	jal	80001308 <yield>
    80001b28:	b75d                	j	80001ace <kerneltrap+0x34>

0000000080001b2a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b2a:	1101                	addi	sp,sp,-32
    80001b2c:	ec06                	sd	ra,24(sp)
    80001b2e:	e822                	sd	s0,16(sp)
    80001b30:	e426                	sd	s1,8(sp)
    80001b32:	1000                	addi	s0,sp,32
    80001b34:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b36:	a30ff0ef          	jal	80000d66 <myproc>
  switch (n) {
    80001b3a:	4795                	li	a5,5
    80001b3c:	0497e163          	bltu	a5,s1,80001b7e <argraw+0x54>
    80001b40:	048a                	slli	s1,s1,0x2
    80001b42:	00006717          	auipc	a4,0x6
    80001b46:	c5e70713          	addi	a4,a4,-930 # 800077a0 <states.0+0x30>
    80001b4a:	94ba                	add	s1,s1,a4
    80001b4c:	409c                	lw	a5,0(s1)
    80001b4e:	97ba                	add	a5,a5,a4
    80001b50:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b52:	6d3c                	ld	a5,88(a0)
    80001b54:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b56:	60e2                	ld	ra,24(sp)
    80001b58:	6442                	ld	s0,16(sp)
    80001b5a:	64a2                	ld	s1,8(sp)
    80001b5c:	6105                	addi	sp,sp,32
    80001b5e:	8082                	ret
    return p->trapframe->a1;
    80001b60:	6d3c                	ld	a5,88(a0)
    80001b62:	7fa8                	ld	a0,120(a5)
    80001b64:	bfcd                	j	80001b56 <argraw+0x2c>
    return p->trapframe->a2;
    80001b66:	6d3c                	ld	a5,88(a0)
    80001b68:	63c8                	ld	a0,128(a5)
    80001b6a:	b7f5                	j	80001b56 <argraw+0x2c>
    return p->trapframe->a3;
    80001b6c:	6d3c                	ld	a5,88(a0)
    80001b6e:	67c8                	ld	a0,136(a5)
    80001b70:	b7dd                	j	80001b56 <argraw+0x2c>
    return p->trapframe->a4;
    80001b72:	6d3c                	ld	a5,88(a0)
    80001b74:	6bc8                	ld	a0,144(a5)
    80001b76:	b7c5                	j	80001b56 <argraw+0x2c>
    return p->trapframe->a5;
    80001b78:	6d3c                	ld	a5,88(a0)
    80001b7a:	6fc8                	ld	a0,152(a5)
    80001b7c:	bfe9                	j	80001b56 <argraw+0x2c>
  panic("argraw");
    80001b7e:	00006517          	auipc	a0,0x6
    80001b82:	82a50513          	addi	a0,a0,-2006 # 800073a8 <etext+0x3a8>
    80001b86:	30d030ef          	jal	80005692 <panic>

0000000080001b8a <fetchaddr>:
{
    80001b8a:	1101                	addi	sp,sp,-32
    80001b8c:	ec06                	sd	ra,24(sp)
    80001b8e:	e822                	sd	s0,16(sp)
    80001b90:	e426                	sd	s1,8(sp)
    80001b92:	e04a                	sd	s2,0(sp)
    80001b94:	1000                	addi	s0,sp,32
    80001b96:	84aa                	mv	s1,a0
    80001b98:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b9a:	9ccff0ef          	jal	80000d66 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001b9e:	653c                	ld	a5,72(a0)
    80001ba0:	02f4f663          	bgeu	s1,a5,80001bcc <fetchaddr+0x42>
    80001ba4:	00848713          	addi	a4,s1,8
    80001ba8:	02e7e463          	bltu	a5,a4,80001bd0 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001bac:	46a1                	li	a3,8
    80001bae:	8626                	mv	a2,s1
    80001bb0:	85ca                	mv	a1,s2
    80001bb2:	6928                	ld	a0,80(a0)
    80001bb4:	efbfe0ef          	jal	80000aae <copyin>
    80001bb8:	00a03533          	snez	a0,a0
    80001bbc:	40a00533          	neg	a0,a0
}
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6902                	ld	s2,0(sp)
    80001bc8:	6105                	addi	sp,sp,32
    80001bca:	8082                	ret
    return -1;
    80001bcc:	557d                	li	a0,-1
    80001bce:	bfcd                	j	80001bc0 <fetchaddr+0x36>
    80001bd0:	557d                	li	a0,-1
    80001bd2:	b7fd                	j	80001bc0 <fetchaddr+0x36>

0000000080001bd4 <fetchstr>:
{
    80001bd4:	7179                	addi	sp,sp,-48
    80001bd6:	f406                	sd	ra,40(sp)
    80001bd8:	f022                	sd	s0,32(sp)
    80001bda:	ec26                	sd	s1,24(sp)
    80001bdc:	e84a                	sd	s2,16(sp)
    80001bde:	e44e                	sd	s3,8(sp)
    80001be0:	1800                	addi	s0,sp,48
    80001be2:	892a                	mv	s2,a0
    80001be4:	84ae                	mv	s1,a1
    80001be6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001be8:	97eff0ef          	jal	80000d66 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bec:	86ce                	mv	a3,s3
    80001bee:	864a                	mv	a2,s2
    80001bf0:	85a6                	mv	a1,s1
    80001bf2:	6928                	ld	a0,80(a0)
    80001bf4:	f41fe0ef          	jal	80000b34 <copyinstr>
    80001bf8:	00054c63          	bltz	a0,80001c10 <fetchstr+0x3c>
  return strlen(buf);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	ec0fe0ef          	jal	800002be <strlen>
}
    80001c02:	70a2                	ld	ra,40(sp)
    80001c04:	7402                	ld	s0,32(sp)
    80001c06:	64e2                	ld	s1,24(sp)
    80001c08:	6942                	ld	s2,16(sp)
    80001c0a:	69a2                	ld	s3,8(sp)
    80001c0c:	6145                	addi	sp,sp,48
    80001c0e:	8082                	ret
    return -1;
    80001c10:	557d                	li	a0,-1
    80001c12:	bfc5                	j	80001c02 <fetchstr+0x2e>

0000000080001c14 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c14:	1101                	addi	sp,sp,-32
    80001c16:	ec06                	sd	ra,24(sp)
    80001c18:	e822                	sd	s0,16(sp)
    80001c1a:	e426                	sd	s1,8(sp)
    80001c1c:	1000                	addi	s0,sp,32
    80001c1e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c20:	f0bff0ef          	jal	80001b2a <argraw>
    80001c24:	c088                	sw	a0,0(s1)
}
    80001c26:	60e2                	ld	ra,24(sp)
    80001c28:	6442                	ld	s0,16(sp)
    80001c2a:	64a2                	ld	s1,8(sp)
    80001c2c:	6105                	addi	sp,sp,32
    80001c2e:	8082                	ret

0000000080001c30 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c30:	1101                	addi	sp,sp,-32
    80001c32:	ec06                	sd	ra,24(sp)
    80001c34:	e822                	sd	s0,16(sp)
    80001c36:	e426                	sd	s1,8(sp)
    80001c38:	1000                	addi	s0,sp,32
    80001c3a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c3c:	eefff0ef          	jal	80001b2a <argraw>
    80001c40:	e088                	sd	a0,0(s1)
}
    80001c42:	60e2                	ld	ra,24(sp)
    80001c44:	6442                	ld	s0,16(sp)
    80001c46:	64a2                	ld	s1,8(sp)
    80001c48:	6105                	addi	sp,sp,32
    80001c4a:	8082                	ret

0000000080001c4c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c4c:	7179                	addi	sp,sp,-48
    80001c4e:	f406                	sd	ra,40(sp)
    80001c50:	f022                	sd	s0,32(sp)
    80001c52:	ec26                	sd	s1,24(sp)
    80001c54:	e84a                	sd	s2,16(sp)
    80001c56:	1800                	addi	s0,sp,48
    80001c58:	84ae                	mv	s1,a1
    80001c5a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001c5c:	fd840593          	addi	a1,s0,-40
    80001c60:	fd1ff0ef          	jal	80001c30 <argaddr>
  return fetchstr(addr, buf, max);
    80001c64:	864a                	mv	a2,s2
    80001c66:	85a6                	mv	a1,s1
    80001c68:	fd843503          	ld	a0,-40(s0)
    80001c6c:	f69ff0ef          	jal	80001bd4 <fetchstr>
}
    80001c70:	70a2                	ld	ra,40(sp)
    80001c72:	7402                	ld	s0,32(sp)
    80001c74:	64e2                	ld	s1,24(sp)
    80001c76:	6942                	ld	s2,16(sp)
    80001c78:	6145                	addi	sp,sp,48
    80001c7a:	8082                	ret

0000000080001c7c <syscall>:
[SYS_symlink] sys_symlink,  // New addition 
};

void
syscall(void)
{
    80001c7c:	1101                	addi	sp,sp,-32
    80001c7e:	ec06                	sd	ra,24(sp)
    80001c80:	e822                	sd	s0,16(sp)
    80001c82:	e426                	sd	s1,8(sp)
    80001c84:	e04a                	sd	s2,0(sp)
    80001c86:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c88:	8deff0ef          	jal	80000d66 <myproc>
    80001c8c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c8e:	05853903          	ld	s2,88(a0)
    80001c92:	0a893783          	ld	a5,168(s2)
    80001c96:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c9a:	37fd                	addiw	a5,a5,-1
    80001c9c:	4755                	li	a4,21
    80001c9e:	00f76f63          	bltu	a4,a5,80001cbc <syscall+0x40>
    80001ca2:	00369713          	slli	a4,a3,0x3
    80001ca6:	00006797          	auipc	a5,0x6
    80001caa:	b1278793          	addi	a5,a5,-1262 # 800077b8 <syscalls>
    80001cae:	97ba                	add	a5,a5,a4
    80001cb0:	639c                	ld	a5,0(a5)
    80001cb2:	c789                	beqz	a5,80001cbc <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001cb4:	9782                	jalr	a5
    80001cb6:	06a93823          	sd	a0,112(s2)
    80001cba:	a829                	j	80001cd4 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001cbc:	15848613          	addi	a2,s1,344
    80001cc0:	588c                	lw	a1,48(s1)
    80001cc2:	00005517          	auipc	a0,0x5
    80001cc6:	6ee50513          	addi	a0,a0,1774 # 800073b0 <etext+0x3b0>
    80001cca:	6f6030ef          	jal	800053c0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cce:	6cbc                	ld	a5,88(s1)
    80001cd0:	577d                	li	a4,-1
    80001cd2:	fbb8                	sd	a4,112(a5)
  }
}
    80001cd4:	60e2                	ld	ra,24(sp)
    80001cd6:	6442                	ld	s0,16(sp)
    80001cd8:	64a2                	ld	s1,8(sp)
    80001cda:	6902                	ld	s2,0(sp)
    80001cdc:	6105                	addi	sp,sp,32
    80001cde:	8082                	ret

0000000080001ce0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001ce0:	1101                	addi	sp,sp,-32
    80001ce2:	ec06                	sd	ra,24(sp)
    80001ce4:	e822                	sd	s0,16(sp)
    80001ce6:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001ce8:	fec40593          	addi	a1,s0,-20
    80001cec:	4501                	li	a0,0
    80001cee:	f27ff0ef          	jal	80001c14 <argint>
  exit(n);
    80001cf2:	fec42503          	lw	a0,-20(s0)
    80001cf6:	f44ff0ef          	jal	8000143a <exit>
  return 0;  // not reached
}
    80001cfa:	4501                	li	a0,0
    80001cfc:	60e2                	ld	ra,24(sp)
    80001cfe:	6442                	ld	s0,16(sp)
    80001d00:	6105                	addi	sp,sp,32
    80001d02:	8082                	ret

0000000080001d04 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d04:	1141                	addi	sp,sp,-16
    80001d06:	e406                	sd	ra,8(sp)
    80001d08:	e022                	sd	s0,0(sp)
    80001d0a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d0c:	85aff0ef          	jal	80000d66 <myproc>
}
    80001d10:	5908                	lw	a0,48(a0)
    80001d12:	60a2                	ld	ra,8(sp)
    80001d14:	6402                	ld	s0,0(sp)
    80001d16:	0141                	addi	sp,sp,16
    80001d18:	8082                	ret

0000000080001d1a <sys_fork>:

uint64
sys_fork(void)
{
    80001d1a:	1141                	addi	sp,sp,-16
    80001d1c:	e406                	sd	ra,8(sp)
    80001d1e:	e022                	sd	s0,0(sp)
    80001d20:	0800                	addi	s0,sp,16
  return fork();
    80001d22:	b6aff0ef          	jal	8000108c <fork>
}
    80001d26:	60a2                	ld	ra,8(sp)
    80001d28:	6402                	ld	s0,0(sp)
    80001d2a:	0141                	addi	sp,sp,16
    80001d2c:	8082                	ret

0000000080001d2e <sys_wait>:

uint64
sys_wait(void)
{
    80001d2e:	1101                	addi	sp,sp,-32
    80001d30:	ec06                	sd	ra,24(sp)
    80001d32:	e822                	sd	s0,16(sp)
    80001d34:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d36:	fe840593          	addi	a1,s0,-24
    80001d3a:	4501                	li	a0,0
    80001d3c:	ef5ff0ef          	jal	80001c30 <argaddr>
  return wait(p);
    80001d40:	fe843503          	ld	a0,-24(s0)
    80001d44:	84dff0ef          	jal	80001590 <wait>
}
    80001d48:	60e2                	ld	ra,24(sp)
    80001d4a:	6442                	ld	s0,16(sp)
    80001d4c:	6105                	addi	sp,sp,32
    80001d4e:	8082                	ret

0000000080001d50 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d50:	7179                	addi	sp,sp,-48
    80001d52:	f406                	sd	ra,40(sp)
    80001d54:	f022                	sd	s0,32(sp)
    80001d56:	ec26                	sd	s1,24(sp)
    80001d58:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d5a:	fdc40593          	addi	a1,s0,-36
    80001d5e:	4501                	li	a0,0
    80001d60:	eb5ff0ef          	jal	80001c14 <argint>
  addr = myproc()->sz;
    80001d64:	802ff0ef          	jal	80000d66 <myproc>
    80001d68:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d6a:	fdc42503          	lw	a0,-36(s0)
    80001d6e:	aceff0ef          	jal	8000103c <growproc>
    80001d72:	00054863          	bltz	a0,80001d82 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d76:	8526                	mv	a0,s1
    80001d78:	70a2                	ld	ra,40(sp)
    80001d7a:	7402                	ld	s0,32(sp)
    80001d7c:	64e2                	ld	s1,24(sp)
    80001d7e:	6145                	addi	sp,sp,48
    80001d80:	8082                	ret
    return -1;
    80001d82:	54fd                	li	s1,-1
    80001d84:	bfcd                	j	80001d76 <sys_sbrk+0x26>

0000000080001d86 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d86:	7139                	addi	sp,sp,-64
    80001d88:	fc06                	sd	ra,56(sp)
    80001d8a:	f822                	sd	s0,48(sp)
    80001d8c:	f04a                	sd	s2,32(sp)
    80001d8e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d90:	fcc40593          	addi	a1,s0,-52
    80001d94:	4501                	li	a0,0
    80001d96:	e7fff0ef          	jal	80001c14 <argint>
  if(n < 0)
    80001d9a:	fcc42783          	lw	a5,-52(s0)
    80001d9e:	0607c763          	bltz	a5,80001e0c <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001da2:	00009517          	auipc	a0,0x9
    80001da6:	77e50513          	addi	a0,a0,1918 # 8000b520 <tickslock>
    80001daa:	417030ef          	jal	800059c0 <acquire>
  ticks0 = ticks;
    80001dae:	00008917          	auipc	s2,0x8
    80001db2:	4fa92903          	lw	s2,1274(s2) # 8000a2a8 <ticks>
  while(ticks - ticks0 < n){
    80001db6:	fcc42783          	lw	a5,-52(s0)
    80001dba:	cf8d                	beqz	a5,80001df4 <sys_sleep+0x6e>
    80001dbc:	f426                	sd	s1,40(sp)
    80001dbe:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001dc0:	00009997          	auipc	s3,0x9
    80001dc4:	76098993          	addi	s3,s3,1888 # 8000b520 <tickslock>
    80001dc8:	00008497          	auipc	s1,0x8
    80001dcc:	4e048493          	addi	s1,s1,1248 # 8000a2a8 <ticks>
    if(killed(myproc())){
    80001dd0:	f97fe0ef          	jal	80000d66 <myproc>
    80001dd4:	f92ff0ef          	jal	80001566 <killed>
    80001dd8:	ed0d                	bnez	a0,80001e12 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001dda:	85ce                	mv	a1,s3
    80001ddc:	8526                	mv	a0,s1
    80001dde:	d56ff0ef          	jal	80001334 <sleep>
  while(ticks - ticks0 < n){
    80001de2:	409c                	lw	a5,0(s1)
    80001de4:	412787bb          	subw	a5,a5,s2
    80001de8:	fcc42703          	lw	a4,-52(s0)
    80001dec:	fee7e2e3          	bltu	a5,a4,80001dd0 <sys_sleep+0x4a>
    80001df0:	74a2                	ld	s1,40(sp)
    80001df2:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001df4:	00009517          	auipc	a0,0x9
    80001df8:	72c50513          	addi	a0,a0,1836 # 8000b520 <tickslock>
    80001dfc:	45d030ef          	jal	80005a58 <release>
  return 0;
    80001e00:	4501                	li	a0,0
}
    80001e02:	70e2                	ld	ra,56(sp)
    80001e04:	7442                	ld	s0,48(sp)
    80001e06:	7902                	ld	s2,32(sp)
    80001e08:	6121                	addi	sp,sp,64
    80001e0a:	8082                	ret
    n = 0;
    80001e0c:	fc042623          	sw	zero,-52(s0)
    80001e10:	bf49                	j	80001da2 <sys_sleep+0x1c>
      release(&tickslock);
    80001e12:	00009517          	auipc	a0,0x9
    80001e16:	70e50513          	addi	a0,a0,1806 # 8000b520 <tickslock>
    80001e1a:	43f030ef          	jal	80005a58 <release>
      return -1;
    80001e1e:	557d                	li	a0,-1
    80001e20:	74a2                	ld	s1,40(sp)
    80001e22:	69e2                	ld	s3,24(sp)
    80001e24:	bff9                	j	80001e02 <sys_sleep+0x7c>

0000000080001e26 <sys_kill>:

uint64
sys_kill(void)
{
    80001e26:	1101                	addi	sp,sp,-32
    80001e28:	ec06                	sd	ra,24(sp)
    80001e2a:	e822                	sd	s0,16(sp)
    80001e2c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e2e:	fec40593          	addi	a1,s0,-20
    80001e32:	4501                	li	a0,0
    80001e34:	de1ff0ef          	jal	80001c14 <argint>
  return kill(pid);
    80001e38:	fec42503          	lw	a0,-20(s0)
    80001e3c:	ea0ff0ef          	jal	800014dc <kill>
}
    80001e40:	60e2                	ld	ra,24(sp)
    80001e42:	6442                	ld	s0,16(sp)
    80001e44:	6105                	addi	sp,sp,32
    80001e46:	8082                	ret

0000000080001e48 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e48:	1101                	addi	sp,sp,-32
    80001e4a:	ec06                	sd	ra,24(sp)
    80001e4c:	e822                	sd	s0,16(sp)
    80001e4e:	e426                	sd	s1,8(sp)
    80001e50:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e52:	00009517          	auipc	a0,0x9
    80001e56:	6ce50513          	addi	a0,a0,1742 # 8000b520 <tickslock>
    80001e5a:	367030ef          	jal	800059c0 <acquire>
  xticks = ticks;
    80001e5e:	00008497          	auipc	s1,0x8
    80001e62:	44a4a483          	lw	s1,1098(s1) # 8000a2a8 <ticks>
  release(&tickslock);
    80001e66:	00009517          	auipc	a0,0x9
    80001e6a:	6ba50513          	addi	a0,a0,1722 # 8000b520 <tickslock>
    80001e6e:	3eb030ef          	jal	80005a58 <release>
  return xticks;
}
    80001e72:	02049513          	slli	a0,s1,0x20
    80001e76:	9101                	srli	a0,a0,0x20
    80001e78:	60e2                	ld	ra,24(sp)
    80001e7a:	6442                	ld	s0,16(sp)
    80001e7c:	64a2                	ld	s1,8(sp)
    80001e7e:	6105                	addi	sp,sp,32
    80001e80:	8082                	ret

0000000080001e82 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e82:	7179                	addi	sp,sp,-48
    80001e84:	f406                	sd	ra,40(sp)
    80001e86:	f022                	sd	s0,32(sp)
    80001e88:	ec26                	sd	s1,24(sp)
    80001e8a:	e84a                	sd	s2,16(sp)
    80001e8c:	e44e                	sd	s3,8(sp)
    80001e8e:	e052                	sd	s4,0(sp)
    80001e90:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e92:	00005597          	auipc	a1,0x5
    80001e96:	53e58593          	addi	a1,a1,1342 # 800073d0 <etext+0x3d0>
    80001e9a:	00009517          	auipc	a0,0x9
    80001e9e:	69e50513          	addi	a0,a0,1694 # 8000b538 <bcache>
    80001ea2:	29f030ef          	jal	80005940 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001ea6:	00011797          	auipc	a5,0x11
    80001eaa:	69278793          	addi	a5,a5,1682 # 80013538 <bcache+0x8000>
    80001eae:	00012717          	auipc	a4,0x12
    80001eb2:	8f270713          	addi	a4,a4,-1806 # 800137a0 <bcache+0x8268>
    80001eb6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001eba:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ebe:	00009497          	auipc	s1,0x9
    80001ec2:	69248493          	addi	s1,s1,1682 # 8000b550 <bcache+0x18>
    b->next = bcache.head.next;
    80001ec6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ec8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001eca:	00005a17          	auipc	s4,0x5
    80001ece:	50ea0a13          	addi	s4,s4,1294 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    80001ed2:	2b893783          	ld	a5,696(s2)
    80001ed6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001ed8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001edc:	85d2                	mv	a1,s4
    80001ede:	01048513          	addi	a0,s1,16
    80001ee2:	38e010ef          	jal	80003270 <initsleeplock>
    bcache.head.next->prev = b;
    80001ee6:	2b893783          	ld	a5,696(s2)
    80001eea:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001eec:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ef0:	45848493          	addi	s1,s1,1112
    80001ef4:	fd349fe3          	bne	s1,s3,80001ed2 <binit+0x50>
  }
}
    80001ef8:	70a2                	ld	ra,40(sp)
    80001efa:	7402                	ld	s0,32(sp)
    80001efc:	64e2                	ld	s1,24(sp)
    80001efe:	6942                	ld	s2,16(sp)
    80001f00:	69a2                	ld	s3,8(sp)
    80001f02:	6a02                	ld	s4,0(sp)
    80001f04:	6145                	addi	sp,sp,48
    80001f06:	8082                	ret

0000000080001f08 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001f08:	7179                	addi	sp,sp,-48
    80001f0a:	f406                	sd	ra,40(sp)
    80001f0c:	f022                	sd	s0,32(sp)
    80001f0e:	ec26                	sd	s1,24(sp)
    80001f10:	e84a                	sd	s2,16(sp)
    80001f12:	e44e                	sd	s3,8(sp)
    80001f14:	1800                	addi	s0,sp,48
    80001f16:	892a                	mv	s2,a0
    80001f18:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001f1a:	00009517          	auipc	a0,0x9
    80001f1e:	61e50513          	addi	a0,a0,1566 # 8000b538 <bcache>
    80001f22:	29f030ef          	jal	800059c0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f26:	00012497          	auipc	s1,0x12
    80001f2a:	8ca4b483          	ld	s1,-1846(s1) # 800137f0 <bcache+0x82b8>
    80001f2e:	00012797          	auipc	a5,0x12
    80001f32:	87278793          	addi	a5,a5,-1934 # 800137a0 <bcache+0x8268>
    80001f36:	02f48b63          	beq	s1,a5,80001f6c <bread+0x64>
    80001f3a:	873e                	mv	a4,a5
    80001f3c:	a021                	j	80001f44 <bread+0x3c>
    80001f3e:	68a4                	ld	s1,80(s1)
    80001f40:	02e48663          	beq	s1,a4,80001f6c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f44:	449c                	lw	a5,8(s1)
    80001f46:	ff279ce3          	bne	a5,s2,80001f3e <bread+0x36>
    80001f4a:	44dc                	lw	a5,12(s1)
    80001f4c:	ff3799e3          	bne	a5,s3,80001f3e <bread+0x36>
      b->refcnt++;
    80001f50:	40bc                	lw	a5,64(s1)
    80001f52:	2785                	addiw	a5,a5,1
    80001f54:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f56:	00009517          	auipc	a0,0x9
    80001f5a:	5e250513          	addi	a0,a0,1506 # 8000b538 <bcache>
    80001f5e:	2fb030ef          	jal	80005a58 <release>
      acquiresleep(&b->lock);
    80001f62:	01048513          	addi	a0,s1,16
    80001f66:	340010ef          	jal	800032a6 <acquiresleep>
      return b;
    80001f6a:	a889                	j	80001fbc <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f6c:	00012497          	auipc	s1,0x12
    80001f70:	87c4b483          	ld	s1,-1924(s1) # 800137e8 <bcache+0x82b0>
    80001f74:	00012797          	auipc	a5,0x12
    80001f78:	82c78793          	addi	a5,a5,-2004 # 800137a0 <bcache+0x8268>
    80001f7c:	00f48863          	beq	s1,a5,80001f8c <bread+0x84>
    80001f80:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f82:	40bc                	lw	a5,64(s1)
    80001f84:	cb91                	beqz	a5,80001f98 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f86:	64a4                	ld	s1,72(s1)
    80001f88:	fee49de3          	bne	s1,a4,80001f82 <bread+0x7a>
  panic("bget: no buffers");
    80001f8c:	00005517          	auipc	a0,0x5
    80001f90:	45450513          	addi	a0,a0,1108 # 800073e0 <etext+0x3e0>
    80001f94:	6fe030ef          	jal	80005692 <panic>
      b->dev = dev;
    80001f98:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001f9c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001fa0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001fa4:	4785                	li	a5,1
    80001fa6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001fa8:	00009517          	auipc	a0,0x9
    80001fac:	59050513          	addi	a0,a0,1424 # 8000b538 <bcache>
    80001fb0:	2a9030ef          	jal	80005a58 <release>
      acquiresleep(&b->lock);
    80001fb4:	01048513          	addi	a0,s1,16
    80001fb8:	2ee010ef          	jal	800032a6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001fbc:	409c                	lw	a5,0(s1)
    80001fbe:	cb89                	beqz	a5,80001fd0 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001fc0:	8526                	mv	a0,s1
    80001fc2:	70a2                	ld	ra,40(sp)
    80001fc4:	7402                	ld	s0,32(sp)
    80001fc6:	64e2                	ld	s1,24(sp)
    80001fc8:	6942                	ld	s2,16(sp)
    80001fca:	69a2                	ld	s3,8(sp)
    80001fcc:	6145                	addi	sp,sp,48
    80001fce:	8082                	ret
    virtio_disk_rw(b, 0);
    80001fd0:	4581                	li	a1,0
    80001fd2:	8526                	mv	a0,s1
    80001fd4:	48d020ef          	jal	80004c60 <virtio_disk_rw>
    b->valid = 1;
    80001fd8:	4785                	li	a5,1
    80001fda:	c09c                	sw	a5,0(s1)
  return b;
    80001fdc:	b7d5                	j	80001fc0 <bread+0xb8>

0000000080001fde <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	1000                	addi	s0,sp,32
    80001fe8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001fea:	0541                	addi	a0,a0,16
    80001fec:	338010ef          	jal	80003324 <holdingsleep>
    80001ff0:	c911                	beqz	a0,80002004 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001ff2:	4585                	li	a1,1
    80001ff4:	8526                	mv	a0,s1
    80001ff6:	46b020ef          	jal	80004c60 <virtio_disk_rw>
}
    80001ffa:	60e2                	ld	ra,24(sp)
    80001ffc:	6442                	ld	s0,16(sp)
    80001ffe:	64a2                	ld	s1,8(sp)
    80002000:	6105                	addi	sp,sp,32
    80002002:	8082                	ret
    panic("bwrite");
    80002004:	00005517          	auipc	a0,0x5
    80002008:	3f450513          	addi	a0,a0,1012 # 800073f8 <etext+0x3f8>
    8000200c:	686030ef          	jal	80005692 <panic>

0000000080002010 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002010:	1101                	addi	sp,sp,-32
    80002012:	ec06                	sd	ra,24(sp)
    80002014:	e822                	sd	s0,16(sp)
    80002016:	e426                	sd	s1,8(sp)
    80002018:	e04a                	sd	s2,0(sp)
    8000201a:	1000                	addi	s0,sp,32
    8000201c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000201e:	01050913          	addi	s2,a0,16
    80002022:	854a                	mv	a0,s2
    80002024:	300010ef          	jal	80003324 <holdingsleep>
    80002028:	c135                	beqz	a0,8000208c <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000202a:	854a                	mv	a0,s2
    8000202c:	2c0010ef          	jal	800032ec <releasesleep>

  acquire(&bcache.lock);
    80002030:	00009517          	auipc	a0,0x9
    80002034:	50850513          	addi	a0,a0,1288 # 8000b538 <bcache>
    80002038:	189030ef          	jal	800059c0 <acquire>
  b->refcnt--;
    8000203c:	40bc                	lw	a5,64(s1)
    8000203e:	37fd                	addiw	a5,a5,-1
    80002040:	0007871b          	sext.w	a4,a5
    80002044:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002046:	e71d                	bnez	a4,80002074 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002048:	68b8                	ld	a4,80(s1)
    8000204a:	64bc                	ld	a5,72(s1)
    8000204c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000204e:	68b8                	ld	a4,80(s1)
    80002050:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002052:	00011797          	auipc	a5,0x11
    80002056:	4e678793          	addi	a5,a5,1254 # 80013538 <bcache+0x8000>
    8000205a:	2b87b703          	ld	a4,696(a5)
    8000205e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002060:	00011717          	auipc	a4,0x11
    80002064:	74070713          	addi	a4,a4,1856 # 800137a0 <bcache+0x8268>
    80002068:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000206a:	2b87b703          	ld	a4,696(a5)
    8000206e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002070:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002074:	00009517          	auipc	a0,0x9
    80002078:	4c450513          	addi	a0,a0,1220 # 8000b538 <bcache>
    8000207c:	1dd030ef          	jal	80005a58 <release>
}
    80002080:	60e2                	ld	ra,24(sp)
    80002082:	6442                	ld	s0,16(sp)
    80002084:	64a2                	ld	s1,8(sp)
    80002086:	6902                	ld	s2,0(sp)
    80002088:	6105                	addi	sp,sp,32
    8000208a:	8082                	ret
    panic("brelse");
    8000208c:	00005517          	auipc	a0,0x5
    80002090:	37450513          	addi	a0,a0,884 # 80007400 <etext+0x400>
    80002094:	5fe030ef          	jal	80005692 <panic>

0000000080002098 <bpin>:

void
bpin(struct buf *b) {
    80002098:	1101                	addi	sp,sp,-32
    8000209a:	ec06                	sd	ra,24(sp)
    8000209c:	e822                	sd	s0,16(sp)
    8000209e:	e426                	sd	s1,8(sp)
    800020a0:	1000                	addi	s0,sp,32
    800020a2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020a4:	00009517          	auipc	a0,0x9
    800020a8:	49450513          	addi	a0,a0,1172 # 8000b538 <bcache>
    800020ac:	115030ef          	jal	800059c0 <acquire>
  b->refcnt++;
    800020b0:	40bc                	lw	a5,64(s1)
    800020b2:	2785                	addiw	a5,a5,1
    800020b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020b6:	00009517          	auipc	a0,0x9
    800020ba:	48250513          	addi	a0,a0,1154 # 8000b538 <bcache>
    800020be:	19b030ef          	jal	80005a58 <release>
}
    800020c2:	60e2                	ld	ra,24(sp)
    800020c4:	6442                	ld	s0,16(sp)
    800020c6:	64a2                	ld	s1,8(sp)
    800020c8:	6105                	addi	sp,sp,32
    800020ca:	8082                	ret

00000000800020cc <bunpin>:

void
bunpin(struct buf *b) {
    800020cc:	1101                	addi	sp,sp,-32
    800020ce:	ec06                	sd	ra,24(sp)
    800020d0:	e822                	sd	s0,16(sp)
    800020d2:	e426                	sd	s1,8(sp)
    800020d4:	1000                	addi	s0,sp,32
    800020d6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020d8:	00009517          	auipc	a0,0x9
    800020dc:	46050513          	addi	a0,a0,1120 # 8000b538 <bcache>
    800020e0:	0e1030ef          	jal	800059c0 <acquire>
  b->refcnt--;
    800020e4:	40bc                	lw	a5,64(s1)
    800020e6:	37fd                	addiw	a5,a5,-1
    800020e8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020ea:	00009517          	auipc	a0,0x9
    800020ee:	44e50513          	addi	a0,a0,1102 # 8000b538 <bcache>
    800020f2:	167030ef          	jal	80005a58 <release>
}
    800020f6:	60e2                	ld	ra,24(sp)
    800020f8:	6442                	ld	s0,16(sp)
    800020fa:	64a2                	ld	s1,8(sp)
    800020fc:	6105                	addi	sp,sp,32
    800020fe:	8082                	ret

0000000080002100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002100:	1101                	addi	sp,sp,-32
    80002102:	ec06                	sd	ra,24(sp)
    80002104:	e822                	sd	s0,16(sp)
    80002106:	e426                	sd	s1,8(sp)
    80002108:	e04a                	sd	s2,0(sp)
    8000210a:	1000                	addi	s0,sp,32
    8000210c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000210e:	00d5d59b          	srliw	a1,a1,0xd
    80002112:	00012797          	auipc	a5,0x12
    80002116:	b027a783          	lw	a5,-1278(a5) # 80013c14 <sb+0x1c>
    8000211a:	9dbd                	addw	a1,a1,a5
    8000211c:	dedff0ef          	jal	80001f08 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002120:	0074f713          	andi	a4,s1,7
    80002124:	4785                	li	a5,1
    80002126:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000212a:	14ce                	slli	s1,s1,0x33
    8000212c:	90d9                	srli	s1,s1,0x36
    8000212e:	00950733          	add	a4,a0,s1
    80002132:	05874703          	lbu	a4,88(a4)
    80002136:	00e7f6b3          	and	a3,a5,a4
    8000213a:	c29d                	beqz	a3,80002160 <bfree+0x60>
    8000213c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000213e:	94aa                	add	s1,s1,a0
    80002140:	fff7c793          	not	a5,a5
    80002144:	8f7d                	and	a4,a4,a5
    80002146:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000214a:	056010ef          	jal	800031a0 <log_write>
  brelse(bp);
    8000214e:	854a                	mv	a0,s2
    80002150:	ec1ff0ef          	jal	80002010 <brelse>
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6902                	ld	s2,0(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret
    panic("freeing free block");
    80002160:	00005517          	auipc	a0,0x5
    80002164:	2a850513          	addi	a0,a0,680 # 80007408 <etext+0x408>
    80002168:	52a030ef          	jal	80005692 <panic>

000000008000216c <balloc>:
{
    8000216c:	711d                	addi	sp,sp,-96
    8000216e:	ec86                	sd	ra,88(sp)
    80002170:	e8a2                	sd	s0,80(sp)
    80002172:	e4a6                	sd	s1,72(sp)
    80002174:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002176:	00012797          	auipc	a5,0x12
    8000217a:	a867a783          	lw	a5,-1402(a5) # 80013bfc <sb+0x4>
    8000217e:	0e078f63          	beqz	a5,8000227c <balloc+0x110>
    80002182:	e0ca                	sd	s2,64(sp)
    80002184:	fc4e                	sd	s3,56(sp)
    80002186:	f852                	sd	s4,48(sp)
    80002188:	f456                	sd	s5,40(sp)
    8000218a:	f05a                	sd	s6,32(sp)
    8000218c:	ec5e                	sd	s7,24(sp)
    8000218e:	e862                	sd	s8,16(sp)
    80002190:	e466                	sd	s9,8(sp)
    80002192:	8baa                	mv	s7,a0
    80002194:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002196:	00012b17          	auipc	s6,0x12
    8000219a:	a62b0b13          	addi	s6,s6,-1438 # 80013bf8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000219e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800021a0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021a2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800021a4:	6c89                	lui	s9,0x2
    800021a6:	a0b5                	j	80002212 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800021a8:	97ca                	add	a5,a5,s2
    800021aa:	8e55                	or	a2,a2,a3
    800021ac:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800021b0:	854a                	mv	a0,s2
    800021b2:	7ef000ef          	jal	800031a0 <log_write>
        brelse(bp);
    800021b6:	854a                	mv	a0,s2
    800021b8:	e59ff0ef          	jal	80002010 <brelse>
  bp = bread(dev, bno);
    800021bc:	85a6                	mv	a1,s1
    800021be:	855e                	mv	a0,s7
    800021c0:	d49ff0ef          	jal	80001f08 <bread>
    800021c4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800021c6:	40000613          	li	a2,1024
    800021ca:	4581                	li	a1,0
    800021cc:	05850513          	addi	a0,a0,88
    800021d0:	f7ffd0ef          	jal	8000014e <memset>
  log_write(bp);
    800021d4:	854a                	mv	a0,s2
    800021d6:	7cb000ef          	jal	800031a0 <log_write>
  brelse(bp);
    800021da:	854a                	mv	a0,s2
    800021dc:	e35ff0ef          	jal	80002010 <brelse>
}
    800021e0:	6906                	ld	s2,64(sp)
    800021e2:	79e2                	ld	s3,56(sp)
    800021e4:	7a42                	ld	s4,48(sp)
    800021e6:	7aa2                	ld	s5,40(sp)
    800021e8:	7b02                	ld	s6,32(sp)
    800021ea:	6be2                	ld	s7,24(sp)
    800021ec:	6c42                	ld	s8,16(sp)
    800021ee:	6ca2                	ld	s9,8(sp)
}
    800021f0:	8526                	mv	a0,s1
    800021f2:	60e6                	ld	ra,88(sp)
    800021f4:	6446                	ld	s0,80(sp)
    800021f6:	64a6                	ld	s1,72(sp)
    800021f8:	6125                	addi	sp,sp,96
    800021fa:	8082                	ret
    brelse(bp);
    800021fc:	854a                	mv	a0,s2
    800021fe:	e13ff0ef          	jal	80002010 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002202:	015c87bb          	addw	a5,s9,s5
    80002206:	00078a9b          	sext.w	s5,a5
    8000220a:	004b2703          	lw	a4,4(s6)
    8000220e:	04eaff63          	bgeu	s5,a4,8000226c <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002212:	41fad79b          	sraiw	a5,s5,0x1f
    80002216:	0137d79b          	srliw	a5,a5,0x13
    8000221a:	015787bb          	addw	a5,a5,s5
    8000221e:	40d7d79b          	sraiw	a5,a5,0xd
    80002222:	01cb2583          	lw	a1,28(s6)
    80002226:	9dbd                	addw	a1,a1,a5
    80002228:	855e                	mv	a0,s7
    8000222a:	cdfff0ef          	jal	80001f08 <bread>
    8000222e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002230:	004b2503          	lw	a0,4(s6)
    80002234:	000a849b          	sext.w	s1,s5
    80002238:	8762                	mv	a4,s8
    8000223a:	fca4f1e3          	bgeu	s1,a0,800021fc <balloc+0x90>
      m = 1 << (bi % 8);
    8000223e:	00777693          	andi	a3,a4,7
    80002242:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002246:	41f7579b          	sraiw	a5,a4,0x1f
    8000224a:	01d7d79b          	srliw	a5,a5,0x1d
    8000224e:	9fb9                	addw	a5,a5,a4
    80002250:	4037d79b          	sraiw	a5,a5,0x3
    80002254:	00f90633          	add	a2,s2,a5
    80002258:	05864603          	lbu	a2,88(a2)
    8000225c:	00c6f5b3          	and	a1,a3,a2
    80002260:	d5a1                	beqz	a1,800021a8 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002262:	2705                	addiw	a4,a4,1
    80002264:	2485                	addiw	s1,s1,1
    80002266:	fd471ae3          	bne	a4,s4,8000223a <balloc+0xce>
    8000226a:	bf49                	j	800021fc <balloc+0x90>
    8000226c:	6906                	ld	s2,64(sp)
    8000226e:	79e2                	ld	s3,56(sp)
    80002270:	7a42                	ld	s4,48(sp)
    80002272:	7aa2                	ld	s5,40(sp)
    80002274:	7b02                	ld	s6,32(sp)
    80002276:	6be2                	ld	s7,24(sp)
    80002278:	6c42                	ld	s8,16(sp)
    8000227a:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000227c:	00005517          	auipc	a0,0x5
    80002280:	1a450513          	addi	a0,a0,420 # 80007420 <etext+0x420>
    80002284:	13c030ef          	jal	800053c0 <printf>
  return 0;
    80002288:	4481                	li	s1,0
    8000228a:	b79d                	j	800021f0 <balloc+0x84>

000000008000228c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000228c:	7139                	addi	sp,sp,-64
    8000228e:	fc06                	sd	ra,56(sp)
    80002290:	f822                	sd	s0,48(sp)
    80002292:	f426                	sd	s1,40(sp)
    80002294:	f04a                	sd	s2,32(sp)
    80002296:	ec4e                	sd	s3,24(sp)
    80002298:	0080                	addi	s0,sp,64
    8000229a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  // Direct blocks (0-10)
  if(bn < NDIRECT){
    8000229c:	47a9                	li	a5,10
    8000229e:	02b7ec63          	bltu	a5,a1,800022d6 <bmap+0x4a>
    if((addr = ip->addrs[bn]) == 0){
    800022a2:	02059793          	slli	a5,a1,0x20
    800022a6:	01e7d593          	srli	a1,a5,0x1e
    800022aa:	00b50933          	add	s2,a0,a1
    800022ae:	05092483          	lw	s1,80(s2)
    800022b2:	c889                	beqz	s1,800022c4 <bmap+0x38>

    brelse(bp);
    return addr;
    }
  panic("bmap: out of range");
}
    800022b4:	8526                	mv	a0,s1
    800022b6:	70e2                	ld	ra,56(sp)
    800022b8:	7442                	ld	s0,48(sp)
    800022ba:	74a2                	ld	s1,40(sp)
    800022bc:	7902                	ld	s2,32(sp)
    800022be:	69e2                	ld	s3,24(sp)
    800022c0:	6121                	addi	sp,sp,64
    800022c2:	8082                	ret
      addr = balloc(ip->dev);
    800022c4:	4108                	lw	a0,0(a0)
    800022c6:	ea7ff0ef          	jal	8000216c <balloc>
    800022ca:	0005049b          	sext.w	s1,a0
      if(addr == 0)
    800022ce:	d0fd                	beqz	s1,800022b4 <bmap+0x28>
      ip->addrs[bn] = addr;
    800022d0:	04992823          	sw	s1,80(s2)
    800022d4:	b7c5                	j	800022b4 <bmap+0x28>
  bn -= NDIRECT;
    800022d6:	ff55891b          	addiw	s2,a1,-11
    800022da:	0009071b          	sext.w	a4,s2
  if(bn < NINDIRECT){
    800022de:	0ff00793          	li	a5,255
    800022e2:	06e7e163          	bltu	a5,a4,80002344 <bmap+0xb8>
    if((addr = ip->addrs[NDIRECT]) == 0){
    800022e6:	5d64                	lw	s1,124(a0)
    800022e8:	e899                	bnez	s1,800022fe <bmap+0x72>
      addr = balloc(ip->dev);
    800022ea:	4108                	lw	a0,0(a0)
    800022ec:	e81ff0ef          	jal	8000216c <balloc>
    800022f0:	0005049b          	sext.w	s1,a0
      if(addr == 0)
    800022f4:	d0e1                	beqz	s1,800022b4 <bmap+0x28>
    800022f6:	e852                	sd	s4,16(sp)
      ip->addrs[NDIRECT] = addr;
    800022f8:	0699ae23          	sw	s1,124(s3)
    800022fc:	a011                	j	80002300 <bmap+0x74>
    800022fe:	e852                	sd	s4,16(sp)
    bp = bread(ip->dev, addr);
    80002300:	85a6                	mv	a1,s1
    80002302:	0009a503          	lw	a0,0(s3)
    80002306:	c03ff0ef          	jal	80001f08 <bread>
    8000230a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000230c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002310:	02091713          	slli	a4,s2,0x20
    80002314:	01e75913          	srli	s2,a4,0x1e
    80002318:	993e                	add	s2,s2,a5
    8000231a:	00092483          	lw	s1,0(s2)
    8000231e:	c491                	beqz	s1,8000232a <bmap+0x9e>
    brelse(bp);
    80002320:	8552                	mv	a0,s4
    80002322:	cefff0ef          	jal	80002010 <brelse>
    return addr;
    80002326:	6a42                	ld	s4,16(sp)
    80002328:	b771                	j	800022b4 <bmap+0x28>
      addr = balloc(ip->dev);
    8000232a:	0009a503          	lw	a0,0(s3)
    8000232e:	e3fff0ef          	jal	8000216c <balloc>
    80002332:	0005049b          	sext.w	s1,a0
      if(addr){
    80002336:	d4ed                	beqz	s1,80002320 <bmap+0x94>
        a[bn] = addr;
    80002338:	00992023          	sw	s1,0(s2)
        log_write(bp);
    8000233c:	8552                	mv	a0,s4
    8000233e:	663000ef          	jal	800031a0 <log_write>
    80002342:	bff9                	j	80002320 <bmap+0x94>
  bn -= NINDIRECT;
    80002344:	ef55891b          	addiw	s2,a1,-267
    80002348:	0009071b          	sext.w	a4,s2
  if (bn < NDOUBLEINDIRECT) {
    8000234c:	67c1                	lui	a5,0x10
    8000234e:	0af77863          	bgeu	a4,a5,800023fe <bmap+0x172>
    if ((addr = ip->addrs[NDIRECT+1]) == 0) {
    80002352:	08052483          	lw	s1,128(a0)
    80002356:	ec81                	bnez	s1,8000236e <bmap+0xe2>
      addr = balloc(ip->dev);
    80002358:	4108                	lw	a0,0(a0)
    8000235a:	e13ff0ef          	jal	8000216c <balloc>
    8000235e:	0005049b          	sext.w	s1,a0
      if (addr == 0)
    80002362:	d8a9                	beqz	s1,800022b4 <bmap+0x28>
    80002364:	e852                	sd	s4,16(sp)
    80002366:	e456                	sd	s5,8(sp)
      ip->addrs[NDIRECT+1] = addr;
    80002368:	0899a023          	sw	s1,128(s3)
    8000236c:	a019                	j	80002372 <bmap+0xe6>
    8000236e:	e852                	sd	s4,16(sp)
    80002370:	e456                	sd	s5,8(sp)
    bp = bread(ip->dev, addr); // Read the double-indirect block
    80002372:	85a6                	mv	a1,s1
    80002374:	0009a503          	lw	a0,0(s3)
    80002378:	b91ff0ef          	jal	80001f08 <bread>
    8000237c:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    8000237e:	05850a93          	addi	s5,a0,88
    if((addr = a[bn/NINDIRECT]) == 0)
    80002382:	0089579b          	srliw	a5,s2,0x8
    80002386:	078a                	slli	a5,a5,0x2
    80002388:	9abe                	add	s5,s5,a5
    8000238a:	000aa483          	lw	s1,0(s5)
    8000238e:	e085                	bnez	s1,800023ae <bmap+0x122>
      addr = balloc(ip->dev);
    80002390:	0009a503          	lw	a0,0(s3)
    80002394:	dd9ff0ef          	jal	8000216c <balloc>
    80002398:	0005049b          	sext.w	s1,a0
      if (addr == 0)
    8000239c:	e481                	bnez	s1,800023a4 <bmap+0x118>
    8000239e:	6a42                	ld	s4,16(sp)
    800023a0:	6aa2                	ld	s5,8(sp)
    800023a2:	bf09                	j	800022b4 <bmap+0x28>
      a[bn/NINDIRECT] = addr;
    800023a4:	009aa023          	sw	s1,0(s5)
      log_write(bp);
    800023a8:	8552                	mv	a0,s4
    800023aa:	5f7000ef          	jal	800031a0 <log_write>
    brelse(bp);
    800023ae:	8552                	mv	a0,s4
    800023b0:	c61ff0ef          	jal	80002010 <brelse>
    bp = bread(ip->dev, addr);
    800023b4:	85a6                	mv	a1,s1
    800023b6:	0009a503          	lw	a0,0(s3)
    800023ba:	b4fff0ef          	jal	80001f08 <bread>
    800023be:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023c0:	05850793          	addi	a5,a0,88
    if ((addr = a[bn%(NINDIRECT)]) == 0) 
    800023c4:	0ff97593          	zext.b	a1,s2
    800023c8:	058a                	slli	a1,a1,0x2
    800023ca:	00b78933          	add	s2,a5,a1
    800023ce:	00092483          	lw	s1,0(s2)
    800023d2:	e085                	bnez	s1,800023f2 <bmap+0x166>
      addr = balloc(ip->dev);
    800023d4:	0009a503          	lw	a0,0(s3)
    800023d8:	d95ff0ef          	jal	8000216c <balloc>
    800023dc:	0005049b          	sext.w	s1,a0
      if (addr == 0)
    800023e0:	e481                	bnez	s1,800023e8 <bmap+0x15c>
    800023e2:	6a42                	ld	s4,16(sp)
    800023e4:	6aa2                	ld	s5,8(sp)
    800023e6:	b5f9                	j	800022b4 <bmap+0x28>
      a[bn%(NINDIRECT)] = addr;
    800023e8:	00992023          	sw	s1,0(s2)
      log_write(bp);
    800023ec:	8552                	mv	a0,s4
    800023ee:	5b3000ef          	jal	800031a0 <log_write>
    brelse(bp);
    800023f2:	8552                	mv	a0,s4
    800023f4:	c1dff0ef          	jal	80002010 <brelse>
    return addr;
    800023f8:	6a42                	ld	s4,16(sp)
    800023fa:	6aa2                	ld	s5,8(sp)
    800023fc:	bd65                	j	800022b4 <bmap+0x28>
    800023fe:	e852                	sd	s4,16(sp)
    80002400:	e456                	sd	s5,8(sp)
  panic("bmap: out of range");
    80002402:	00005517          	auipc	a0,0x5
    80002406:	03650513          	addi	a0,a0,54 # 80007438 <etext+0x438>
    8000240a:	288030ef          	jal	80005692 <panic>

000000008000240e <iget>:
{
    8000240e:	7179                	addi	sp,sp,-48
    80002410:	f406                	sd	ra,40(sp)
    80002412:	f022                	sd	s0,32(sp)
    80002414:	ec26                	sd	s1,24(sp)
    80002416:	e84a                	sd	s2,16(sp)
    80002418:	e44e                	sd	s3,8(sp)
    8000241a:	e052                	sd	s4,0(sp)
    8000241c:	1800                	addi	s0,sp,48
    8000241e:	89aa                	mv	s3,a0
    80002420:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002422:	00011517          	auipc	a0,0x11
    80002426:	7f650513          	addi	a0,a0,2038 # 80013c18 <itable>
    8000242a:	596030ef          	jal	800059c0 <acquire>
  empty = 0;
    8000242e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002430:	00012497          	auipc	s1,0x12
    80002434:	80048493          	addi	s1,s1,-2048 # 80013c30 <itable+0x18>
    80002438:	00013697          	auipc	a3,0x13
    8000243c:	28868693          	addi	a3,a3,648 # 800156c0 <log>
    80002440:	a039                	j	8000244e <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002442:	02090963          	beqz	s2,80002474 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002446:	08848493          	addi	s1,s1,136
    8000244a:	02d48863          	beq	s1,a3,8000247a <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000244e:	449c                	lw	a5,8(s1)
    80002450:	fef059e3          	blez	a5,80002442 <iget+0x34>
    80002454:	4098                	lw	a4,0(s1)
    80002456:	ff3716e3          	bne	a4,s3,80002442 <iget+0x34>
    8000245a:	40d8                	lw	a4,4(s1)
    8000245c:	ff4713e3          	bne	a4,s4,80002442 <iget+0x34>
      ip->ref++;
    80002460:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    80002462:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002464:	00011517          	auipc	a0,0x11
    80002468:	7b450513          	addi	a0,a0,1972 # 80013c18 <itable>
    8000246c:	5ec030ef          	jal	80005a58 <release>
      return ip;
    80002470:	8926                	mv	s2,s1
    80002472:	a02d                	j	8000249c <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002474:	fbe9                	bnez	a5,80002446 <iget+0x38>
      empty = ip;
    80002476:	8926                	mv	s2,s1
    80002478:	b7f9                	j	80002446 <iget+0x38>
  if(empty == 0)
    8000247a:	02090a63          	beqz	s2,800024ae <iget+0xa0>
  ip->dev = dev;
    8000247e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002482:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002486:	4785                	li	a5,1
    80002488:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000248c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002490:	00011517          	auipc	a0,0x11
    80002494:	78850513          	addi	a0,a0,1928 # 80013c18 <itable>
    80002498:	5c0030ef          	jal	80005a58 <release>
}
    8000249c:	854a                	mv	a0,s2
    8000249e:	70a2                	ld	ra,40(sp)
    800024a0:	7402                	ld	s0,32(sp)
    800024a2:	64e2                	ld	s1,24(sp)
    800024a4:	6942                	ld	s2,16(sp)
    800024a6:	69a2                	ld	s3,8(sp)
    800024a8:	6a02                	ld	s4,0(sp)
    800024aa:	6145                	addi	sp,sp,48
    800024ac:	8082                	ret
    panic("iget: no inodes");
    800024ae:	00005517          	auipc	a0,0x5
    800024b2:	fa250513          	addi	a0,a0,-94 # 80007450 <etext+0x450>
    800024b6:	1dc030ef          	jal	80005692 <panic>

00000000800024ba <fsinit>:
fsinit(int dev) {
    800024ba:	7179                	addi	sp,sp,-48
    800024bc:	f406                	sd	ra,40(sp)
    800024be:	f022                	sd	s0,32(sp)
    800024c0:	ec26                	sd	s1,24(sp)
    800024c2:	e84a                	sd	s2,16(sp)
    800024c4:	e44e                	sd	s3,8(sp)
    800024c6:	1800                	addi	s0,sp,48
    800024c8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800024ca:	4585                	li	a1,1
    800024cc:	a3dff0ef          	jal	80001f08 <bread>
    800024d0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800024d2:	00011997          	auipc	s3,0x11
    800024d6:	72698993          	addi	s3,s3,1830 # 80013bf8 <sb>
    800024da:	02000613          	li	a2,32
    800024de:	05850593          	addi	a1,a0,88
    800024e2:	854e                	mv	a0,s3
    800024e4:	cc7fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    800024e8:	8526                	mv	a0,s1
    800024ea:	b27ff0ef          	jal	80002010 <brelse>
  if(sb.magic != FSMAGIC)
    800024ee:	0009a703          	lw	a4,0(s3)
    800024f2:	102037b7          	lui	a5,0x10203
    800024f6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800024fa:	02f71063          	bne	a4,a5,8000251a <fsinit+0x60>
  initlog(dev, &sb);
    800024fe:	00011597          	auipc	a1,0x11
    80002502:	6fa58593          	addi	a1,a1,1786 # 80013bf8 <sb>
    80002506:	854a                	mv	a0,s2
    80002508:	291000ef          	jal	80002f98 <initlog>
}
    8000250c:	70a2                	ld	ra,40(sp)
    8000250e:	7402                	ld	s0,32(sp)
    80002510:	64e2                	ld	s1,24(sp)
    80002512:	6942                	ld	s2,16(sp)
    80002514:	69a2                	ld	s3,8(sp)
    80002516:	6145                	addi	sp,sp,48
    80002518:	8082                	ret
    panic("invalid file system");
    8000251a:	00005517          	auipc	a0,0x5
    8000251e:	f4650513          	addi	a0,a0,-186 # 80007460 <etext+0x460>
    80002522:	170030ef          	jal	80005692 <panic>

0000000080002526 <iinit>:
{
    80002526:	7179                	addi	sp,sp,-48
    80002528:	f406                	sd	ra,40(sp)
    8000252a:	f022                	sd	s0,32(sp)
    8000252c:	ec26                	sd	s1,24(sp)
    8000252e:	e84a                	sd	s2,16(sp)
    80002530:	e44e                	sd	s3,8(sp)
    80002532:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002534:	00005597          	auipc	a1,0x5
    80002538:	f4458593          	addi	a1,a1,-188 # 80007478 <etext+0x478>
    8000253c:	00011517          	auipc	a0,0x11
    80002540:	6dc50513          	addi	a0,a0,1756 # 80013c18 <itable>
    80002544:	3fc030ef          	jal	80005940 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002548:	00011497          	auipc	s1,0x11
    8000254c:	6f848493          	addi	s1,s1,1784 # 80013c40 <itable+0x28>
    80002550:	00013997          	auipc	s3,0x13
    80002554:	18098993          	addi	s3,s3,384 # 800156d0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002558:	00005917          	auipc	s2,0x5
    8000255c:	f2890913          	addi	s2,s2,-216 # 80007480 <etext+0x480>
    80002560:	85ca                	mv	a1,s2
    80002562:	8526                	mv	a0,s1
    80002564:	50d000ef          	jal	80003270 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002568:	08848493          	addi	s1,s1,136
    8000256c:	ff349ae3          	bne	s1,s3,80002560 <iinit+0x3a>
}
    80002570:	70a2                	ld	ra,40(sp)
    80002572:	7402                	ld	s0,32(sp)
    80002574:	64e2                	ld	s1,24(sp)
    80002576:	6942                	ld	s2,16(sp)
    80002578:	69a2                	ld	s3,8(sp)
    8000257a:	6145                	addi	sp,sp,48
    8000257c:	8082                	ret

000000008000257e <ialloc>:
{
    8000257e:	7139                	addi	sp,sp,-64
    80002580:	fc06                	sd	ra,56(sp)
    80002582:	f822                	sd	s0,48(sp)
    80002584:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002586:	00011717          	auipc	a4,0x11
    8000258a:	67e72703          	lw	a4,1662(a4) # 80013c04 <sb+0xc>
    8000258e:	4785                	li	a5,1
    80002590:	06e7f063          	bgeu	a5,a4,800025f0 <ialloc+0x72>
    80002594:	f426                	sd	s1,40(sp)
    80002596:	f04a                	sd	s2,32(sp)
    80002598:	ec4e                	sd	s3,24(sp)
    8000259a:	e852                	sd	s4,16(sp)
    8000259c:	e456                	sd	s5,8(sp)
    8000259e:	e05a                	sd	s6,0(sp)
    800025a0:	8aaa                	mv	s5,a0
    800025a2:	8b2e                	mv	s6,a1
    800025a4:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800025a6:	00011a17          	auipc	s4,0x11
    800025aa:	652a0a13          	addi	s4,s4,1618 # 80013bf8 <sb>
    800025ae:	00495593          	srli	a1,s2,0x4
    800025b2:	018a2783          	lw	a5,24(s4)
    800025b6:	9dbd                	addw	a1,a1,a5
    800025b8:	8556                	mv	a0,s5
    800025ba:	94fff0ef          	jal	80001f08 <bread>
    800025be:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025c0:	05850993          	addi	s3,a0,88
    800025c4:	00f97793          	andi	a5,s2,15
    800025c8:	079a                	slli	a5,a5,0x6
    800025ca:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025cc:	00099783          	lh	a5,0(s3)
    800025d0:	cb9d                	beqz	a5,80002606 <ialloc+0x88>
    brelse(bp);
    800025d2:	a3fff0ef          	jal	80002010 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025d6:	0905                	addi	s2,s2,1
    800025d8:	00ca2703          	lw	a4,12(s4)
    800025dc:	0009079b          	sext.w	a5,s2
    800025e0:	fce7e7e3          	bltu	a5,a4,800025ae <ialloc+0x30>
    800025e4:	74a2                	ld	s1,40(sp)
    800025e6:	7902                	ld	s2,32(sp)
    800025e8:	69e2                	ld	s3,24(sp)
    800025ea:	6a42                	ld	s4,16(sp)
    800025ec:	6aa2                	ld	s5,8(sp)
    800025ee:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800025f0:	00005517          	auipc	a0,0x5
    800025f4:	e9850513          	addi	a0,a0,-360 # 80007488 <etext+0x488>
    800025f8:	5c9020ef          	jal	800053c0 <printf>
  return 0;
    800025fc:	4501                	li	a0,0
}
    800025fe:	70e2                	ld	ra,56(sp)
    80002600:	7442                	ld	s0,48(sp)
    80002602:	6121                	addi	sp,sp,64
    80002604:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002606:	04000613          	li	a2,64
    8000260a:	4581                	li	a1,0
    8000260c:	854e                	mv	a0,s3
    8000260e:	b41fd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002612:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002616:	8526                	mv	a0,s1
    80002618:	389000ef          	jal	800031a0 <log_write>
      brelse(bp);
    8000261c:	8526                	mv	a0,s1
    8000261e:	9f3ff0ef          	jal	80002010 <brelse>
      return iget(dev, inum);
    80002622:	0009059b          	sext.w	a1,s2
    80002626:	8556                	mv	a0,s5
    80002628:	de7ff0ef          	jal	8000240e <iget>
    8000262c:	74a2                	ld	s1,40(sp)
    8000262e:	7902                	ld	s2,32(sp)
    80002630:	69e2                	ld	s3,24(sp)
    80002632:	6a42                	ld	s4,16(sp)
    80002634:	6aa2                	ld	s5,8(sp)
    80002636:	6b02                	ld	s6,0(sp)
    80002638:	b7d9                	j	800025fe <ialloc+0x80>

000000008000263a <iupdate>:
{
    8000263a:	1101                	addi	sp,sp,-32
    8000263c:	ec06                	sd	ra,24(sp)
    8000263e:	e822                	sd	s0,16(sp)
    80002640:	e426                	sd	s1,8(sp)
    80002642:	e04a                	sd	s2,0(sp)
    80002644:	1000                	addi	s0,sp,32
    80002646:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002648:	415c                	lw	a5,4(a0)
    8000264a:	0047d79b          	srliw	a5,a5,0x4
    8000264e:	00011597          	auipc	a1,0x11
    80002652:	5c25a583          	lw	a1,1474(a1) # 80013c10 <sb+0x18>
    80002656:	9dbd                	addw	a1,a1,a5
    80002658:	4108                	lw	a0,0(a0)
    8000265a:	8afff0ef          	jal	80001f08 <bread>
    8000265e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002660:	05850793          	addi	a5,a0,88
    80002664:	40d8                	lw	a4,4(s1)
    80002666:	8b3d                	andi	a4,a4,15
    80002668:	071a                	slli	a4,a4,0x6
    8000266a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000266c:	04449703          	lh	a4,68(s1)
    80002670:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002674:	04649703          	lh	a4,70(s1)
    80002678:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000267c:	04849703          	lh	a4,72(s1)
    80002680:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002684:	04a49703          	lh	a4,74(s1)
    80002688:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000268c:	44f8                	lw	a4,76(s1)
    8000268e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002690:	03400613          	li	a2,52
    80002694:	05048593          	addi	a1,s1,80
    80002698:	00c78513          	addi	a0,a5,12
    8000269c:	b0ffd0ef          	jal	800001aa <memmove>
  log_write(bp);
    800026a0:	854a                	mv	a0,s2
    800026a2:	2ff000ef          	jal	800031a0 <log_write>
  brelse(bp);
    800026a6:	854a                	mv	a0,s2
    800026a8:	969ff0ef          	jal	80002010 <brelse>
}
    800026ac:	60e2                	ld	ra,24(sp)
    800026ae:	6442                	ld	s0,16(sp)
    800026b0:	64a2                	ld	s1,8(sp)
    800026b2:	6902                	ld	s2,0(sp)
    800026b4:	6105                	addi	sp,sp,32
    800026b6:	8082                	ret

00000000800026b8 <idup>:
{
    800026b8:	1101                	addi	sp,sp,-32
    800026ba:	ec06                	sd	ra,24(sp)
    800026bc:	e822                	sd	s0,16(sp)
    800026be:	e426                	sd	s1,8(sp)
    800026c0:	1000                	addi	s0,sp,32
    800026c2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026c4:	00011517          	auipc	a0,0x11
    800026c8:	55450513          	addi	a0,a0,1364 # 80013c18 <itable>
    800026cc:	2f4030ef          	jal	800059c0 <acquire>
  ip->ref++;
    800026d0:	449c                	lw	a5,8(s1)
    800026d2:	2785                	addiw	a5,a5,1
    800026d4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026d6:	00011517          	auipc	a0,0x11
    800026da:	54250513          	addi	a0,a0,1346 # 80013c18 <itable>
    800026de:	37a030ef          	jal	80005a58 <release>
}
    800026e2:	8526                	mv	a0,s1
    800026e4:	60e2                	ld	ra,24(sp)
    800026e6:	6442                	ld	s0,16(sp)
    800026e8:	64a2                	ld	s1,8(sp)
    800026ea:	6105                	addi	sp,sp,32
    800026ec:	8082                	ret

00000000800026ee <ilock>:
{
    800026ee:	1101                	addi	sp,sp,-32
    800026f0:	ec06                	sd	ra,24(sp)
    800026f2:	e822                	sd	s0,16(sp)
    800026f4:	e426                	sd	s1,8(sp)
    800026f6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026f8:	cd19                	beqz	a0,80002716 <ilock+0x28>
    800026fa:	84aa                	mv	s1,a0
    800026fc:	451c                	lw	a5,8(a0)
    800026fe:	00f05c63          	blez	a5,80002716 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002702:	0541                	addi	a0,a0,16
    80002704:	3a3000ef          	jal	800032a6 <acquiresleep>
  if(ip->valid == 0){
    80002708:	40bc                	lw	a5,64(s1)
    8000270a:	cf89                	beqz	a5,80002724 <ilock+0x36>
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6105                	addi	sp,sp,32
    80002714:	8082                	ret
    80002716:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002718:	00005517          	auipc	a0,0x5
    8000271c:	d8850513          	addi	a0,a0,-632 # 800074a0 <etext+0x4a0>
    80002720:	773020ef          	jal	80005692 <panic>
    80002724:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002726:	40dc                	lw	a5,4(s1)
    80002728:	0047d79b          	srliw	a5,a5,0x4
    8000272c:	00011597          	auipc	a1,0x11
    80002730:	4e45a583          	lw	a1,1252(a1) # 80013c10 <sb+0x18>
    80002734:	9dbd                	addw	a1,a1,a5
    80002736:	4088                	lw	a0,0(s1)
    80002738:	fd0ff0ef          	jal	80001f08 <bread>
    8000273c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000273e:	05850593          	addi	a1,a0,88
    80002742:	40dc                	lw	a5,4(s1)
    80002744:	8bbd                	andi	a5,a5,15
    80002746:	079a                	slli	a5,a5,0x6
    80002748:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000274a:	00059783          	lh	a5,0(a1)
    8000274e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002752:	00259783          	lh	a5,2(a1)
    80002756:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000275a:	00459783          	lh	a5,4(a1)
    8000275e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002762:	00659783          	lh	a5,6(a1)
    80002766:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000276a:	459c                	lw	a5,8(a1)
    8000276c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000276e:	03400613          	li	a2,52
    80002772:	05b1                	addi	a1,a1,12
    80002774:	05048513          	addi	a0,s1,80
    80002778:	a33fd0ef          	jal	800001aa <memmove>
    brelse(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	893ff0ef          	jal	80002010 <brelse>
    ip->valid = 1;
    80002782:	4785                	li	a5,1
    80002784:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002786:	04449783          	lh	a5,68(s1)
    8000278a:	c399                	beqz	a5,80002790 <ilock+0xa2>
    8000278c:	6902                	ld	s2,0(sp)
    8000278e:	bfbd                	j	8000270c <ilock+0x1e>
      panic("ilock: no type");
    80002790:	00005517          	auipc	a0,0x5
    80002794:	d1850513          	addi	a0,a0,-744 # 800074a8 <etext+0x4a8>
    80002798:	6fb020ef          	jal	80005692 <panic>

000000008000279c <iunlock>:
{
    8000279c:	1101                	addi	sp,sp,-32
    8000279e:	ec06                	sd	ra,24(sp)
    800027a0:	e822                	sd	s0,16(sp)
    800027a2:	e426                	sd	s1,8(sp)
    800027a4:	e04a                	sd	s2,0(sp)
    800027a6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027a8:	c505                	beqz	a0,800027d0 <iunlock+0x34>
    800027aa:	84aa                	mv	s1,a0
    800027ac:	01050913          	addi	s2,a0,16
    800027b0:	854a                	mv	a0,s2
    800027b2:	373000ef          	jal	80003324 <holdingsleep>
    800027b6:	cd09                	beqz	a0,800027d0 <iunlock+0x34>
    800027b8:	449c                	lw	a5,8(s1)
    800027ba:	00f05b63          	blez	a5,800027d0 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027be:	854a                	mv	a0,s2
    800027c0:	32d000ef          	jal	800032ec <releasesleep>
}
    800027c4:	60e2                	ld	ra,24(sp)
    800027c6:	6442                	ld	s0,16(sp)
    800027c8:	64a2                	ld	s1,8(sp)
    800027ca:	6902                	ld	s2,0(sp)
    800027cc:	6105                	addi	sp,sp,32
    800027ce:	8082                	ret
    panic("iunlock");
    800027d0:	00005517          	auipc	a0,0x5
    800027d4:	ce850513          	addi	a0,a0,-792 # 800074b8 <etext+0x4b8>
    800027d8:	6bb020ef          	jal	80005692 <panic>

00000000800027dc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027dc:	715d                	addi	sp,sp,-80
    800027de:	e486                	sd	ra,72(sp)
    800027e0:	e0a2                	sd	s0,64(sp)
    800027e2:	fc26                	sd	s1,56(sp)
    800027e4:	f84a                	sd	s2,48(sp)
    800027e6:	f44e                	sd	s3,40(sp)
    800027e8:	0880                	addi	s0,sp,80
    800027ea:	89aa                	mv	s3,a0
  int i, j, k, m;
  struct buf *bp, *bp1;
  uint *a, *a1;

  //This is for the direct blocks.
  for(i = 0; i < NDIRECT; i++){
    800027ec:	05050493          	addi	s1,a0,80
    800027f0:	07c50913          	addi	s2,a0,124
    800027f4:	a021                	j	800027fc <itrunc+0x20>
    800027f6:	0491                	addi	s1,s1,4
    800027f8:	01248b63          	beq	s1,s2,8000280e <itrunc+0x32>
    if(ip->addrs[i]){
    800027fc:	408c                	lw	a1,0(s1)
    800027fe:	dde5                	beqz	a1,800027f6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002800:	0009a503          	lw	a0,0(s3)
    80002804:	8fdff0ef          	jal	80002100 <bfree>
      ip->addrs[i] = 0;
    80002808:	0004a023          	sw	zero,0(s1)
    8000280c:	b7ed                	j	800027f6 <itrunc+0x1a>
    }
  }

  // This is single indirect block
  if(ip->addrs[NDIRECT]){
    8000280e:	07c9a583          	lw	a1,124(s3)
    80002812:	e185                	bnez	a1,80002832 <itrunc+0x56>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  // This is the double indirect block
  if(ip->addrs[NDIRECT+1])
    80002814:	0809a583          	lw	a1,128(s3)
    80002818:	edb9                	bnez	a1,80002876 <itrunc+0x9a>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    ip->addrs[NDIRECT+1] = 0;
  }

  ip->size = 0;
    8000281a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000281e:	854e                	mv	a0,s3
    80002820:	e1bff0ef          	jal	8000263a <iupdate>
}
    80002824:	60a6                	ld	ra,72(sp)
    80002826:	6406                	ld	s0,64(sp)
    80002828:	74e2                	ld	s1,56(sp)
    8000282a:	7942                	ld	s2,48(sp)
    8000282c:	79a2                	ld	s3,40(sp)
    8000282e:	6161                	addi	sp,sp,80
    80002830:	8082                	ret
    80002832:	f052                	sd	s4,32(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002834:	0009a503          	lw	a0,0(s3)
    80002838:	ed0ff0ef          	jal	80001f08 <bread>
    8000283c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000283e:	05850493          	addi	s1,a0,88
    80002842:	45850913          	addi	s2,a0,1112
    80002846:	a021                	j	8000284e <itrunc+0x72>
    80002848:	0491                	addi	s1,s1,4
    8000284a:	01248963          	beq	s1,s2,8000285c <itrunc+0x80>
      if(a[j])
    8000284e:	408c                	lw	a1,0(s1)
    80002850:	dde5                	beqz	a1,80002848 <itrunc+0x6c>
        bfree(ip->dev, a[j]);
    80002852:	0009a503          	lw	a0,0(s3)
    80002856:	8abff0ef          	jal	80002100 <bfree>
    8000285a:	b7fd                	j	80002848 <itrunc+0x6c>
    brelse(bp);
    8000285c:	8552                	mv	a0,s4
    8000285e:	fb2ff0ef          	jal	80002010 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002862:	07c9a583          	lw	a1,124(s3)
    80002866:	0009a503          	lw	a0,0(s3)
    8000286a:	897ff0ef          	jal	80002100 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000286e:	0609ae23          	sw	zero,124(s3)
    80002872:	7a02                	ld	s4,32(sp)
    80002874:	b745                	j	80002814 <itrunc+0x38>
    80002876:	f052                	sd	s4,32(sp)
    80002878:	ec56                	sd	s5,24(sp)
    8000287a:	e85a                	sd	s6,16(sp)
    8000287c:	e45e                	sd	s7,8(sp)
    8000287e:	e062                	sd	s8,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
    80002880:	0009a503          	lw	a0,0(s3)
    80002884:	e84ff0ef          	jal	80001f08 <bread>
    80002888:	8c2a                	mv	s8,a0
    for(k = 0; k < NINDIRECT; k++)
    8000288a:	05850a13          	addi	s4,a0,88
    8000288e:	45850b13          	addi	s6,a0,1112
    80002892:	a81d                	j	800028c8 <itrunc+0xec>
        for(m = 0; m< NINDIRECT; m++)
    80002894:	0491                	addi	s1,s1,4
    80002896:	01248b63          	beq	s1,s2,800028ac <itrunc+0xd0>
          if(a1[m])
    8000289a:	408c                	lw	a1,0(s1)
    8000289c:	dde5                	beqz	a1,80002894 <itrunc+0xb8>
            bfree(ip->dev, a1[m]);
    8000289e:	0009a503          	lw	a0,0(s3)
    800028a2:	85fff0ef          	jal	80002100 <bfree>
            a1[m] = 0;
    800028a6:	0004a023          	sw	zero,0(s1)
    800028aa:	b7ed                	j	80002894 <itrunc+0xb8>
        brelse(bp1);
    800028ac:	855e                	mv	a0,s7
    800028ae:	f62ff0ef          	jal	80002010 <brelse>
        bfree(ip->dev, a[k]);
    800028b2:	000aa583          	lw	a1,0(s5)
    800028b6:	0009a503          	lw	a0,0(s3)
    800028ba:	847ff0ef          	jal	80002100 <bfree>
        a[k] = 0;
    800028be:	000aa023          	sw	zero,0(s5)
    for(k = 0; k < NINDIRECT; k++)
    800028c2:	0a11                	addi	s4,s4,4
    800028c4:	036a0063          	beq	s4,s6,800028e4 <itrunc+0x108>
      if(a[k])
    800028c8:	8ad2                	mv	s5,s4
    800028ca:	000a2583          	lw	a1,0(s4)
    800028ce:	d9f5                	beqz	a1,800028c2 <itrunc+0xe6>
        bp1 = bread(ip->dev, a[k]); 
    800028d0:	0009a503          	lw	a0,0(s3)
    800028d4:	e34ff0ef          	jal	80001f08 <bread>
    800028d8:	8baa                	mv	s7,a0
        for(m = 0; m< NINDIRECT; m++)
    800028da:	05850493          	addi	s1,a0,88
    800028de:	45850913          	addi	s2,a0,1112
    800028e2:	bf65                	j	8000289a <itrunc+0xbe>
    brelse(bp);
    800028e4:	8562                	mv	a0,s8
    800028e6:	f2aff0ef          	jal	80002010 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    800028ea:	0809a583          	lw	a1,128(s3)
    800028ee:	0009a503          	lw	a0,0(s3)
    800028f2:	80fff0ef          	jal	80002100 <bfree>
    ip->addrs[NDIRECT+1] = 0;
    800028f6:	0809a023          	sw	zero,128(s3)
    800028fa:	7a02                	ld	s4,32(sp)
    800028fc:	6ae2                	ld	s5,24(sp)
    800028fe:	6b42                	ld	s6,16(sp)
    80002900:	6ba2                	ld	s7,8(sp)
    80002902:	6c02                	ld	s8,0(sp)
    80002904:	bf19                	j	8000281a <itrunc+0x3e>

0000000080002906 <iput>:
{
    80002906:	1101                	addi	sp,sp,-32
    80002908:	ec06                	sd	ra,24(sp)
    8000290a:	e822                	sd	s0,16(sp)
    8000290c:	e426                	sd	s1,8(sp)
    8000290e:	1000                	addi	s0,sp,32
    80002910:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002912:	00011517          	auipc	a0,0x11
    80002916:	30650513          	addi	a0,a0,774 # 80013c18 <itable>
    8000291a:	0a6030ef          	jal	800059c0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000291e:	4498                	lw	a4,8(s1)
    80002920:	4785                	li	a5,1
    80002922:	02f70063          	beq	a4,a5,80002942 <iput+0x3c>
  ip->ref--;
    80002926:	449c                	lw	a5,8(s1)
    80002928:	37fd                	addiw	a5,a5,-1
    8000292a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000292c:	00011517          	auipc	a0,0x11
    80002930:	2ec50513          	addi	a0,a0,748 # 80013c18 <itable>
    80002934:	124030ef          	jal	80005a58 <release>
}
    80002938:	60e2                	ld	ra,24(sp)
    8000293a:	6442                	ld	s0,16(sp)
    8000293c:	64a2                	ld	s1,8(sp)
    8000293e:	6105                	addi	sp,sp,32
    80002940:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002942:	40bc                	lw	a5,64(s1)
    80002944:	d3ed                	beqz	a5,80002926 <iput+0x20>
    80002946:	04a49783          	lh	a5,74(s1)
    8000294a:	fff1                	bnez	a5,80002926 <iput+0x20>
    8000294c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000294e:	01048913          	addi	s2,s1,16
    80002952:	854a                	mv	a0,s2
    80002954:	153000ef          	jal	800032a6 <acquiresleep>
    release(&itable.lock);
    80002958:	00011517          	auipc	a0,0x11
    8000295c:	2c050513          	addi	a0,a0,704 # 80013c18 <itable>
    80002960:	0f8030ef          	jal	80005a58 <release>
    itrunc(ip);
    80002964:	8526                	mv	a0,s1
    80002966:	e77ff0ef          	jal	800027dc <itrunc>
    ip->type = 0;
    8000296a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000296e:	8526                	mv	a0,s1
    80002970:	ccbff0ef          	jal	8000263a <iupdate>
    ip->valid = 0;
    80002974:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002978:	854a                	mv	a0,s2
    8000297a:	173000ef          	jal	800032ec <releasesleep>
    acquire(&itable.lock);
    8000297e:	00011517          	auipc	a0,0x11
    80002982:	29a50513          	addi	a0,a0,666 # 80013c18 <itable>
    80002986:	03a030ef          	jal	800059c0 <acquire>
    8000298a:	6902                	ld	s2,0(sp)
    8000298c:	bf69                	j	80002926 <iput+0x20>

000000008000298e <iunlockput>:
{
    8000298e:	1101                	addi	sp,sp,-32
    80002990:	ec06                	sd	ra,24(sp)
    80002992:	e822                	sd	s0,16(sp)
    80002994:	e426                	sd	s1,8(sp)
    80002996:	1000                	addi	s0,sp,32
    80002998:	84aa                	mv	s1,a0
  iunlock(ip);
    8000299a:	e03ff0ef          	jal	8000279c <iunlock>
  iput(ip);
    8000299e:	8526                	mv	a0,s1
    800029a0:	f67ff0ef          	jal	80002906 <iput>
}
    800029a4:	60e2                	ld	ra,24(sp)
    800029a6:	6442                	ld	s0,16(sp)
    800029a8:	64a2                	ld	s1,8(sp)
    800029aa:	6105                	addi	sp,sp,32
    800029ac:	8082                	ret

00000000800029ae <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800029ae:	1141                	addi	sp,sp,-16
    800029b0:	e422                	sd	s0,8(sp)
    800029b2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800029b4:	411c                	lw	a5,0(a0)
    800029b6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800029b8:	415c                	lw	a5,4(a0)
    800029ba:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800029bc:	04451783          	lh	a5,68(a0)
    800029c0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800029c4:	04a51783          	lh	a5,74(a0)
    800029c8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029cc:	04c56783          	lwu	a5,76(a0)
    800029d0:	e99c                	sd	a5,16(a1)
}
    800029d2:	6422                	ld	s0,8(sp)
    800029d4:	0141                	addi	sp,sp,16
    800029d6:	8082                	ret

00000000800029d8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029d8:	457c                	lw	a5,76(a0)
    800029da:	0ed7eb63          	bltu	a5,a3,80002ad0 <readi+0xf8>
{
    800029de:	7159                	addi	sp,sp,-112
    800029e0:	f486                	sd	ra,104(sp)
    800029e2:	f0a2                	sd	s0,96(sp)
    800029e4:	eca6                	sd	s1,88(sp)
    800029e6:	e0d2                	sd	s4,64(sp)
    800029e8:	fc56                	sd	s5,56(sp)
    800029ea:	f85a                	sd	s6,48(sp)
    800029ec:	f45e                	sd	s7,40(sp)
    800029ee:	1880                	addi	s0,sp,112
    800029f0:	8b2a                	mv	s6,a0
    800029f2:	8bae                	mv	s7,a1
    800029f4:	8a32                	mv	s4,a2
    800029f6:	84b6                	mv	s1,a3
    800029f8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029fa:	9f35                	addw	a4,a4,a3
    return 0;
    800029fc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029fe:	0cd76063          	bltu	a4,a3,80002abe <readi+0xe6>
    80002a02:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a04:	00e7f463          	bgeu	a5,a4,80002a0c <readi+0x34>
    n = ip->size - off;
    80002a08:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a0c:	080a8f63          	beqz	s5,80002aaa <readi+0xd2>
    80002a10:	e8ca                	sd	s2,80(sp)
    80002a12:	f062                	sd	s8,32(sp)
    80002a14:	ec66                	sd	s9,24(sp)
    80002a16:	e86a                	sd	s10,16(sp)
    80002a18:	e46e                	sd	s11,8(sp)
    80002a1a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a1c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a20:	5c7d                	li	s8,-1
    80002a22:	a80d                	j	80002a54 <readi+0x7c>
    80002a24:	020d1d93          	slli	s11,s10,0x20
    80002a28:	020ddd93          	srli	s11,s11,0x20
    80002a2c:	05890613          	addi	a2,s2,88
    80002a30:	86ee                	mv	a3,s11
    80002a32:	963a                	add	a2,a2,a4
    80002a34:	85d2                	mv	a1,s4
    80002a36:	855e                	mv	a0,s7
    80002a38:	c53fe0ef          	jal	8000168a <either_copyout>
    80002a3c:	05850763          	beq	a0,s8,80002a8a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a40:	854a                	mv	a0,s2
    80002a42:	dceff0ef          	jal	80002010 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a46:	013d09bb          	addw	s3,s10,s3
    80002a4a:	009d04bb          	addw	s1,s10,s1
    80002a4e:	9a6e                	add	s4,s4,s11
    80002a50:	0559f763          	bgeu	s3,s5,80002a9e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002a54:	00a4d59b          	srliw	a1,s1,0xa
    80002a58:	855a                	mv	a0,s6
    80002a5a:	833ff0ef          	jal	8000228c <bmap>
    80002a5e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a62:	c5b1                	beqz	a1,80002aae <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002a64:	000b2503          	lw	a0,0(s6)
    80002a68:	ca0ff0ef          	jal	80001f08 <bread>
    80002a6c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a6e:	3ff4f713          	andi	a4,s1,1023
    80002a72:	40ec87bb          	subw	a5,s9,a4
    80002a76:	413a86bb          	subw	a3,s5,s3
    80002a7a:	8d3e                	mv	s10,a5
    80002a7c:	2781                	sext.w	a5,a5
    80002a7e:	0006861b          	sext.w	a2,a3
    80002a82:	faf671e3          	bgeu	a2,a5,80002a24 <readi+0x4c>
    80002a86:	8d36                	mv	s10,a3
    80002a88:	bf71                	j	80002a24 <readi+0x4c>
      brelse(bp);
    80002a8a:	854a                	mv	a0,s2
    80002a8c:	d84ff0ef          	jal	80002010 <brelse>
      tot = -1;
    80002a90:	59fd                	li	s3,-1
      break;
    80002a92:	6946                	ld	s2,80(sp)
    80002a94:	7c02                	ld	s8,32(sp)
    80002a96:	6ce2                	ld	s9,24(sp)
    80002a98:	6d42                	ld	s10,16(sp)
    80002a9a:	6da2                	ld	s11,8(sp)
    80002a9c:	a831                	j	80002ab8 <readi+0xe0>
    80002a9e:	6946                	ld	s2,80(sp)
    80002aa0:	7c02                	ld	s8,32(sp)
    80002aa2:	6ce2                	ld	s9,24(sp)
    80002aa4:	6d42                	ld	s10,16(sp)
    80002aa6:	6da2                	ld	s11,8(sp)
    80002aa8:	a801                	j	80002ab8 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002aaa:	89d6                	mv	s3,s5
    80002aac:	a031                	j	80002ab8 <readi+0xe0>
    80002aae:	6946                	ld	s2,80(sp)
    80002ab0:	7c02                	ld	s8,32(sp)
    80002ab2:	6ce2                	ld	s9,24(sp)
    80002ab4:	6d42                	ld	s10,16(sp)
    80002ab6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002ab8:	0009851b          	sext.w	a0,s3
    80002abc:	69a6                	ld	s3,72(sp)
}
    80002abe:	70a6                	ld	ra,104(sp)
    80002ac0:	7406                	ld	s0,96(sp)
    80002ac2:	64e6                	ld	s1,88(sp)
    80002ac4:	6a06                	ld	s4,64(sp)
    80002ac6:	7ae2                	ld	s5,56(sp)
    80002ac8:	7b42                	ld	s6,48(sp)
    80002aca:	7ba2                	ld	s7,40(sp)
    80002acc:	6165                	addi	sp,sp,112
    80002ace:	8082                	ret
    return 0;
    80002ad0:	4501                	li	a0,0
}
    80002ad2:	8082                	ret

0000000080002ad4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ad4:	457c                	lw	a5,76(a0)
    80002ad6:	10d7e163          	bltu	a5,a3,80002bd8 <writei+0x104>
{
    80002ada:	7159                	addi	sp,sp,-112
    80002adc:	f486                	sd	ra,104(sp)
    80002ade:	f0a2                	sd	s0,96(sp)
    80002ae0:	e8ca                	sd	s2,80(sp)
    80002ae2:	e0d2                	sd	s4,64(sp)
    80002ae4:	fc56                	sd	s5,56(sp)
    80002ae6:	f85a                	sd	s6,48(sp)
    80002ae8:	f45e                	sd	s7,40(sp)
    80002aea:	1880                	addi	s0,sp,112
    80002aec:	8aaa                	mv	s5,a0
    80002aee:	8bae                	mv	s7,a1
    80002af0:	8a32                	mv	s4,a2
    80002af2:	8936                	mv	s2,a3
    80002af4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002af6:	9f35                	addw	a4,a4,a3
    80002af8:	0ed76263          	bltu	a4,a3,80002bdc <writei+0x108>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002afc:	040437b7          	lui	a5,0x4043
    80002b00:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80002b04:	0ce7ee63          	bltu	a5,a4,80002be0 <writei+0x10c>
    80002b08:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b0a:	0a0b0f63          	beqz	s6,80002bc8 <writei+0xf4>
    80002b0e:	eca6                	sd	s1,88(sp)
    80002b10:	f062                	sd	s8,32(sp)
    80002b12:	ec66                	sd	s9,24(sp)
    80002b14:	e86a                	sd	s10,16(sp)
    80002b16:	e46e                	sd	s11,8(sp)
    80002b18:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b1a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b1e:	5c7d                	li	s8,-1
    80002b20:	a825                	j	80002b58 <writei+0x84>
    80002b22:	020d1d93          	slli	s11,s10,0x20
    80002b26:	020ddd93          	srli	s11,s11,0x20
    80002b2a:	05848513          	addi	a0,s1,88
    80002b2e:	86ee                	mv	a3,s11
    80002b30:	8652                	mv	a2,s4
    80002b32:	85de                	mv	a1,s7
    80002b34:	953a                	add	a0,a0,a4
    80002b36:	b9ffe0ef          	jal	800016d4 <either_copyin>
    80002b3a:	05850a63          	beq	a0,s8,80002b8e <writei+0xba>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b3e:	8526                	mv	a0,s1
    80002b40:	660000ef          	jal	800031a0 <log_write>
    brelse(bp);
    80002b44:	8526                	mv	a0,s1
    80002b46:	ccaff0ef          	jal	80002010 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b4a:	013d09bb          	addw	s3,s10,s3
    80002b4e:	012d093b          	addw	s2,s10,s2
    80002b52:	9a6e                	add	s4,s4,s11
    80002b54:	0569f063          	bgeu	s3,s6,80002b94 <writei+0xc0>
    uint addr = bmap(ip, off/BSIZE);
    80002b58:	00a9559b          	srliw	a1,s2,0xa
    80002b5c:	8556                	mv	a0,s5
    80002b5e:	f2eff0ef          	jal	8000228c <bmap>
    80002b62:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b66:	c59d                	beqz	a1,80002b94 <writei+0xc0>
    bp = bread(ip->dev, addr);
    80002b68:	000aa503          	lw	a0,0(s5)
    80002b6c:	b9cff0ef          	jal	80001f08 <bread>
    80002b70:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b72:	3ff97713          	andi	a4,s2,1023
    80002b76:	40ec87bb          	subw	a5,s9,a4
    80002b7a:	413b06bb          	subw	a3,s6,s3
    80002b7e:	8d3e                	mv	s10,a5
    80002b80:	2781                	sext.w	a5,a5
    80002b82:	0006861b          	sext.w	a2,a3
    80002b86:	f8f67ee3          	bgeu	a2,a5,80002b22 <writei+0x4e>
    80002b8a:	8d36                	mv	s10,a3
    80002b8c:	bf59                	j	80002b22 <writei+0x4e>
      brelse(bp);
    80002b8e:	8526                	mv	a0,s1
    80002b90:	c80ff0ef          	jal	80002010 <brelse>
  }

  if(off > ip->size)
    80002b94:	04caa783          	lw	a5,76(s5)
    80002b98:	0327fa63          	bgeu	a5,s2,80002bcc <writei+0xf8>
    ip->size = off;
    80002b9c:	052aa623          	sw	s2,76(s5)
    80002ba0:	64e6                	ld	s1,88(sp)
    80002ba2:	7c02                	ld	s8,32(sp)
    80002ba4:	6ce2                	ld	s9,24(sp)
    80002ba6:	6d42                	ld	s10,16(sp)
    80002ba8:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002baa:	8556                	mv	a0,s5
    80002bac:	a8fff0ef          	jal	8000263a <iupdate>

  return tot;
    80002bb0:	0009851b          	sext.w	a0,s3
    80002bb4:	69a6                	ld	s3,72(sp)
}
    80002bb6:	70a6                	ld	ra,104(sp)
    80002bb8:	7406                	ld	s0,96(sp)
    80002bba:	6946                	ld	s2,80(sp)
    80002bbc:	6a06                	ld	s4,64(sp)
    80002bbe:	7ae2                	ld	s5,56(sp)
    80002bc0:	7b42                	ld	s6,48(sp)
    80002bc2:	7ba2                	ld	s7,40(sp)
    80002bc4:	6165                	addi	sp,sp,112
    80002bc6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bc8:	89da                	mv	s3,s6
    80002bca:	b7c5                	j	80002baa <writei+0xd6>
    80002bcc:	64e6                	ld	s1,88(sp)
    80002bce:	7c02                	ld	s8,32(sp)
    80002bd0:	6ce2                	ld	s9,24(sp)
    80002bd2:	6d42                	ld	s10,16(sp)
    80002bd4:	6da2                	ld	s11,8(sp)
    80002bd6:	bfd1                	j	80002baa <writei+0xd6>
    return -1;
    80002bd8:	557d                	li	a0,-1
}
    80002bda:	8082                	ret
    return -1;
    80002bdc:	557d                	li	a0,-1
    80002bde:	bfe1                	j	80002bb6 <writei+0xe2>
    return -1;
    80002be0:	557d                	li	a0,-1
    80002be2:	bfd1                	j	80002bb6 <writei+0xe2>

0000000080002be4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002be4:	1141                	addi	sp,sp,-16
    80002be6:	e406                	sd	ra,8(sp)
    80002be8:	e022                	sd	s0,0(sp)
    80002bea:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002bec:	4639                	li	a2,14
    80002bee:	e2cfd0ef          	jal	8000021a <strncmp>
}
    80002bf2:	60a2                	ld	ra,8(sp)
    80002bf4:	6402                	ld	s0,0(sp)
    80002bf6:	0141                	addi	sp,sp,16
    80002bf8:	8082                	ret

0000000080002bfa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002bfa:	7139                	addi	sp,sp,-64
    80002bfc:	fc06                	sd	ra,56(sp)
    80002bfe:	f822                	sd	s0,48(sp)
    80002c00:	f426                	sd	s1,40(sp)
    80002c02:	f04a                	sd	s2,32(sp)
    80002c04:	ec4e                	sd	s3,24(sp)
    80002c06:	e852                	sd	s4,16(sp)
    80002c08:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c0a:	04451703          	lh	a4,68(a0)
    80002c0e:	4785                	li	a5,1
    80002c10:	00f71a63          	bne	a4,a5,80002c24 <dirlookup+0x2a>
    80002c14:	892a                	mv	s2,a0
    80002c16:	89ae                	mv	s3,a1
    80002c18:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c1a:	457c                	lw	a5,76(a0)
    80002c1c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c1e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c20:	e39d                	bnez	a5,80002c46 <dirlookup+0x4c>
    80002c22:	a095                	j	80002c86 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c24:	00005517          	auipc	a0,0x5
    80002c28:	89c50513          	addi	a0,a0,-1892 # 800074c0 <etext+0x4c0>
    80002c2c:	267020ef          	jal	80005692 <panic>
      panic("dirlookup read");
    80002c30:	00005517          	auipc	a0,0x5
    80002c34:	8a850513          	addi	a0,a0,-1880 # 800074d8 <etext+0x4d8>
    80002c38:	25b020ef          	jal	80005692 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c3c:	24c1                	addiw	s1,s1,16
    80002c3e:	04c92783          	lw	a5,76(s2)
    80002c42:	04f4f163          	bgeu	s1,a5,80002c84 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c46:	4741                	li	a4,16
    80002c48:	86a6                	mv	a3,s1
    80002c4a:	fc040613          	addi	a2,s0,-64
    80002c4e:	4581                	li	a1,0
    80002c50:	854a                	mv	a0,s2
    80002c52:	d87ff0ef          	jal	800029d8 <readi>
    80002c56:	47c1                	li	a5,16
    80002c58:	fcf51ce3          	bne	a0,a5,80002c30 <dirlookup+0x36>
    if(de.inum == 0)
    80002c5c:	fc045783          	lhu	a5,-64(s0)
    80002c60:	dff1                	beqz	a5,80002c3c <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002c62:	fc240593          	addi	a1,s0,-62
    80002c66:	854e                	mv	a0,s3
    80002c68:	f7dff0ef          	jal	80002be4 <namecmp>
    80002c6c:	f961                	bnez	a0,80002c3c <dirlookup+0x42>
      if(poff)
    80002c6e:	000a0463          	beqz	s4,80002c76 <dirlookup+0x7c>
        *poff = off;
    80002c72:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c76:	fc045583          	lhu	a1,-64(s0)
    80002c7a:	00092503          	lw	a0,0(s2)
    80002c7e:	f90ff0ef          	jal	8000240e <iget>
    80002c82:	a011                	j	80002c86 <dirlookup+0x8c>
  return 0;
    80002c84:	4501                	li	a0,0
}
    80002c86:	70e2                	ld	ra,56(sp)
    80002c88:	7442                	ld	s0,48(sp)
    80002c8a:	74a2                	ld	s1,40(sp)
    80002c8c:	7902                	ld	s2,32(sp)
    80002c8e:	69e2                	ld	s3,24(sp)
    80002c90:	6a42                	ld	s4,16(sp)
    80002c92:	6121                	addi	sp,sp,64
    80002c94:	8082                	ret

0000000080002c96 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c96:	711d                	addi	sp,sp,-96
    80002c98:	ec86                	sd	ra,88(sp)
    80002c9a:	e8a2                	sd	s0,80(sp)
    80002c9c:	e4a6                	sd	s1,72(sp)
    80002c9e:	e0ca                	sd	s2,64(sp)
    80002ca0:	fc4e                	sd	s3,56(sp)
    80002ca2:	f852                	sd	s4,48(sp)
    80002ca4:	f456                	sd	s5,40(sp)
    80002ca6:	f05a                	sd	s6,32(sp)
    80002ca8:	ec5e                	sd	s7,24(sp)
    80002caa:	e862                	sd	s8,16(sp)
    80002cac:	e466                	sd	s9,8(sp)
    80002cae:	1080                	addi	s0,sp,96
    80002cb0:	84aa                	mv	s1,a0
    80002cb2:	8b2e                	mv	s6,a1
    80002cb4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002cb6:	00054703          	lbu	a4,0(a0)
    80002cba:	02f00793          	li	a5,47
    80002cbe:	00f70e63          	beq	a4,a5,80002cda <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002cc2:	8a4fe0ef          	jal	80000d66 <myproc>
    80002cc6:	15053503          	ld	a0,336(a0)
    80002cca:	9efff0ef          	jal	800026b8 <idup>
    80002cce:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002cd0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002cd4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002cd6:	4b85                	li	s7,1
    80002cd8:	a871                	j	80002d74 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002cda:	4585                	li	a1,1
    80002cdc:	4505                	li	a0,1
    80002cde:	f30ff0ef          	jal	8000240e <iget>
    80002ce2:	8a2a                	mv	s4,a0
    80002ce4:	b7f5                	j	80002cd0 <namex+0x3a>
      iunlockput(ip);
    80002ce6:	8552                	mv	a0,s4
    80002ce8:	ca7ff0ef          	jal	8000298e <iunlockput>
      return 0;
    80002cec:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002cee:	8552                	mv	a0,s4
    80002cf0:	60e6                	ld	ra,88(sp)
    80002cf2:	6446                	ld	s0,80(sp)
    80002cf4:	64a6                	ld	s1,72(sp)
    80002cf6:	6906                	ld	s2,64(sp)
    80002cf8:	79e2                	ld	s3,56(sp)
    80002cfa:	7a42                	ld	s4,48(sp)
    80002cfc:	7aa2                	ld	s5,40(sp)
    80002cfe:	7b02                	ld	s6,32(sp)
    80002d00:	6be2                	ld	s7,24(sp)
    80002d02:	6c42                	ld	s8,16(sp)
    80002d04:	6ca2                	ld	s9,8(sp)
    80002d06:	6125                	addi	sp,sp,96
    80002d08:	8082                	ret
      iunlock(ip);
    80002d0a:	8552                	mv	a0,s4
    80002d0c:	a91ff0ef          	jal	8000279c <iunlock>
      return ip;
    80002d10:	bff9                	j	80002cee <namex+0x58>
      iunlockput(ip);
    80002d12:	8552                	mv	a0,s4
    80002d14:	c7bff0ef          	jal	8000298e <iunlockput>
      return 0;
    80002d18:	8a4e                	mv	s4,s3
    80002d1a:	bfd1                	j	80002cee <namex+0x58>
  len = path - s;
    80002d1c:	40998633          	sub	a2,s3,s1
    80002d20:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d24:	099c5063          	bge	s8,s9,80002da4 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d28:	4639                	li	a2,14
    80002d2a:	85a6                	mv	a1,s1
    80002d2c:	8556                	mv	a0,s5
    80002d2e:	c7cfd0ef          	jal	800001aa <memmove>
    80002d32:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d34:	0004c783          	lbu	a5,0(s1)
    80002d38:	01279763          	bne	a5,s2,80002d46 <namex+0xb0>
    path++;
    80002d3c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d3e:	0004c783          	lbu	a5,0(s1)
    80002d42:	ff278de3          	beq	a5,s2,80002d3c <namex+0xa6>
    ilock(ip);
    80002d46:	8552                	mv	a0,s4
    80002d48:	9a7ff0ef          	jal	800026ee <ilock>
    if(ip->type != T_DIR){
    80002d4c:	044a1783          	lh	a5,68(s4)
    80002d50:	f9779be3          	bne	a5,s7,80002ce6 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002d54:	000b0563          	beqz	s6,80002d5e <namex+0xc8>
    80002d58:	0004c783          	lbu	a5,0(s1)
    80002d5c:	d7dd                	beqz	a5,80002d0a <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d5e:	4601                	li	a2,0
    80002d60:	85d6                	mv	a1,s5
    80002d62:	8552                	mv	a0,s4
    80002d64:	e97ff0ef          	jal	80002bfa <dirlookup>
    80002d68:	89aa                	mv	s3,a0
    80002d6a:	d545                	beqz	a0,80002d12 <namex+0x7c>
    iunlockput(ip);
    80002d6c:	8552                	mv	a0,s4
    80002d6e:	c21ff0ef          	jal	8000298e <iunlockput>
    ip = next;
    80002d72:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d74:	0004c783          	lbu	a5,0(s1)
    80002d78:	01279763          	bne	a5,s2,80002d86 <namex+0xf0>
    path++;
    80002d7c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d7e:	0004c783          	lbu	a5,0(s1)
    80002d82:	ff278de3          	beq	a5,s2,80002d7c <namex+0xe6>
  if(*path == 0)
    80002d86:	cb8d                	beqz	a5,80002db8 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002d88:	0004c783          	lbu	a5,0(s1)
    80002d8c:	89a6                	mv	s3,s1
  len = path - s;
    80002d8e:	4c81                	li	s9,0
    80002d90:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d92:	01278963          	beq	a5,s2,80002da4 <namex+0x10e>
    80002d96:	d3d9                	beqz	a5,80002d1c <namex+0x86>
    path++;
    80002d98:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d9a:	0009c783          	lbu	a5,0(s3)
    80002d9e:	ff279ce3          	bne	a5,s2,80002d96 <namex+0x100>
    80002da2:	bfad                	j	80002d1c <namex+0x86>
    memmove(name, s, len);
    80002da4:	2601                	sext.w	a2,a2
    80002da6:	85a6                	mv	a1,s1
    80002da8:	8556                	mv	a0,s5
    80002daa:	c00fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002dae:	9cd6                	add	s9,s9,s5
    80002db0:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002db4:	84ce                	mv	s1,s3
    80002db6:	bfbd                	j	80002d34 <namex+0x9e>
  if(nameiparent){
    80002db8:	f20b0be3          	beqz	s6,80002cee <namex+0x58>
    iput(ip);
    80002dbc:	8552                	mv	a0,s4
    80002dbe:	b49ff0ef          	jal	80002906 <iput>
    return 0;
    80002dc2:	4a01                	li	s4,0
    80002dc4:	b72d                	j	80002cee <namex+0x58>

0000000080002dc6 <dirlink>:
{
    80002dc6:	7139                	addi	sp,sp,-64
    80002dc8:	fc06                	sd	ra,56(sp)
    80002dca:	f822                	sd	s0,48(sp)
    80002dcc:	f04a                	sd	s2,32(sp)
    80002dce:	ec4e                	sd	s3,24(sp)
    80002dd0:	e852                	sd	s4,16(sp)
    80002dd2:	0080                	addi	s0,sp,64
    80002dd4:	892a                	mv	s2,a0
    80002dd6:	8a2e                	mv	s4,a1
    80002dd8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002dda:	4601                	li	a2,0
    80002ddc:	e1fff0ef          	jal	80002bfa <dirlookup>
    80002de0:	e535                	bnez	a0,80002e4c <dirlink+0x86>
    80002de2:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002de4:	04c92483          	lw	s1,76(s2)
    80002de8:	c48d                	beqz	s1,80002e12 <dirlink+0x4c>
    80002dea:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dec:	4741                	li	a4,16
    80002dee:	86a6                	mv	a3,s1
    80002df0:	fc040613          	addi	a2,s0,-64
    80002df4:	4581                	li	a1,0
    80002df6:	854a                	mv	a0,s2
    80002df8:	be1ff0ef          	jal	800029d8 <readi>
    80002dfc:	47c1                	li	a5,16
    80002dfe:	04f51b63          	bne	a0,a5,80002e54 <dirlink+0x8e>
    if(de.inum == 0)
    80002e02:	fc045783          	lhu	a5,-64(s0)
    80002e06:	c791                	beqz	a5,80002e12 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e08:	24c1                	addiw	s1,s1,16
    80002e0a:	04c92783          	lw	a5,76(s2)
    80002e0e:	fcf4efe3          	bltu	s1,a5,80002dec <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e12:	4639                	li	a2,14
    80002e14:	85d2                	mv	a1,s4
    80002e16:	fc240513          	addi	a0,s0,-62
    80002e1a:	c36fd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002e1e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e22:	4741                	li	a4,16
    80002e24:	86a6                	mv	a3,s1
    80002e26:	fc040613          	addi	a2,s0,-64
    80002e2a:	4581                	li	a1,0
    80002e2c:	854a                	mv	a0,s2
    80002e2e:	ca7ff0ef          	jal	80002ad4 <writei>
    80002e32:	1541                	addi	a0,a0,-16
    80002e34:	00a03533          	snez	a0,a0
    80002e38:	40a00533          	neg	a0,a0
    80002e3c:	74a2                	ld	s1,40(sp)
}
    80002e3e:	70e2                	ld	ra,56(sp)
    80002e40:	7442                	ld	s0,48(sp)
    80002e42:	7902                	ld	s2,32(sp)
    80002e44:	69e2                	ld	s3,24(sp)
    80002e46:	6a42                	ld	s4,16(sp)
    80002e48:	6121                	addi	sp,sp,64
    80002e4a:	8082                	ret
    iput(ip);
    80002e4c:	abbff0ef          	jal	80002906 <iput>
    return -1;
    80002e50:	557d                	li	a0,-1
    80002e52:	b7f5                	j	80002e3e <dirlink+0x78>
      panic("dirlink read");
    80002e54:	00004517          	auipc	a0,0x4
    80002e58:	69450513          	addi	a0,a0,1684 # 800074e8 <etext+0x4e8>
    80002e5c:	037020ef          	jal	80005692 <panic>

0000000080002e60 <namei>:

struct inode*
namei(char *path)
{
    80002e60:	1101                	addi	sp,sp,-32
    80002e62:	ec06                	sd	ra,24(sp)
    80002e64:	e822                	sd	s0,16(sp)
    80002e66:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e68:	fe040613          	addi	a2,s0,-32
    80002e6c:	4581                	li	a1,0
    80002e6e:	e29ff0ef          	jal	80002c96 <namex>
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	6105                	addi	sp,sp,32
    80002e78:	8082                	ret

0000000080002e7a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e7a:	1141                	addi	sp,sp,-16
    80002e7c:	e406                	sd	ra,8(sp)
    80002e7e:	e022                	sd	s0,0(sp)
    80002e80:	0800                	addi	s0,sp,16
    80002e82:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e84:	4585                	li	a1,1
    80002e86:	e11ff0ef          	jal	80002c96 <namex>
}
    80002e8a:	60a2                	ld	ra,8(sp)
    80002e8c:	6402                	ld	s0,0(sp)
    80002e8e:	0141                	addi	sp,sp,16
    80002e90:	8082                	ret

0000000080002e92 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e92:	1101                	addi	sp,sp,-32
    80002e94:	ec06                	sd	ra,24(sp)
    80002e96:	e822                	sd	s0,16(sp)
    80002e98:	e426                	sd	s1,8(sp)
    80002e9a:	e04a                	sd	s2,0(sp)
    80002e9c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e9e:	00013917          	auipc	s2,0x13
    80002ea2:	82290913          	addi	s2,s2,-2014 # 800156c0 <log>
    80002ea6:	01892583          	lw	a1,24(s2)
    80002eaa:	02892503          	lw	a0,40(s2)
    80002eae:	85aff0ef          	jal	80001f08 <bread>
    80002eb2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002eb4:	02c92603          	lw	a2,44(s2)
    80002eb8:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002eba:	00c05f63          	blez	a2,80002ed8 <write_head+0x46>
    80002ebe:	00013717          	auipc	a4,0x13
    80002ec2:	83270713          	addi	a4,a4,-1998 # 800156f0 <log+0x30>
    80002ec6:	87aa                	mv	a5,a0
    80002ec8:	060a                	slli	a2,a2,0x2
    80002eca:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002ecc:	4314                	lw	a3,0(a4)
    80002ece:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002ed0:	0711                	addi	a4,a4,4
    80002ed2:	0791                	addi	a5,a5,4
    80002ed4:	fec79ce3          	bne	a5,a2,80002ecc <write_head+0x3a>
  }
  bwrite(buf);
    80002ed8:	8526                	mv	a0,s1
    80002eda:	904ff0ef          	jal	80001fde <bwrite>
  brelse(buf);
    80002ede:	8526                	mv	a0,s1
    80002ee0:	930ff0ef          	jal	80002010 <brelse>
}
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	64a2                	ld	s1,8(sp)
    80002eea:	6902                	ld	s2,0(sp)
    80002eec:	6105                	addi	sp,sp,32
    80002eee:	8082                	ret

0000000080002ef0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ef0:	00012797          	auipc	a5,0x12
    80002ef4:	7fc7a783          	lw	a5,2044(a5) # 800156ec <log+0x2c>
    80002ef8:	08f05f63          	blez	a5,80002f96 <install_trans+0xa6>
{
    80002efc:	7139                	addi	sp,sp,-64
    80002efe:	fc06                	sd	ra,56(sp)
    80002f00:	f822                	sd	s0,48(sp)
    80002f02:	f426                	sd	s1,40(sp)
    80002f04:	f04a                	sd	s2,32(sp)
    80002f06:	ec4e                	sd	s3,24(sp)
    80002f08:	e852                	sd	s4,16(sp)
    80002f0a:	e456                	sd	s5,8(sp)
    80002f0c:	e05a                	sd	s6,0(sp)
    80002f0e:	0080                	addi	s0,sp,64
    80002f10:	8b2a                	mv	s6,a0
    80002f12:	00012a97          	auipc	s5,0x12
    80002f16:	7dea8a93          	addi	s5,s5,2014 # 800156f0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f1a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f1c:	00012997          	auipc	s3,0x12
    80002f20:	7a498993          	addi	s3,s3,1956 # 800156c0 <log>
    80002f24:	a829                	j	80002f3e <install_trans+0x4e>
    brelse(lbuf);
    80002f26:	854a                	mv	a0,s2
    80002f28:	8e8ff0ef          	jal	80002010 <brelse>
    brelse(dbuf);
    80002f2c:	8526                	mv	a0,s1
    80002f2e:	8e2ff0ef          	jal	80002010 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f32:	2a05                	addiw	s4,s4,1
    80002f34:	0a91                	addi	s5,s5,4
    80002f36:	02c9a783          	lw	a5,44(s3)
    80002f3a:	04fa5463          	bge	s4,a5,80002f82 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f3e:	0189a583          	lw	a1,24(s3)
    80002f42:	014585bb          	addw	a1,a1,s4
    80002f46:	2585                	addiw	a1,a1,1
    80002f48:	0289a503          	lw	a0,40(s3)
    80002f4c:	fbdfe0ef          	jal	80001f08 <bread>
    80002f50:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f52:	000aa583          	lw	a1,0(s5)
    80002f56:	0289a503          	lw	a0,40(s3)
    80002f5a:	faffe0ef          	jal	80001f08 <bread>
    80002f5e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f60:	40000613          	li	a2,1024
    80002f64:	05890593          	addi	a1,s2,88
    80002f68:	05850513          	addi	a0,a0,88
    80002f6c:	a3efd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f70:	8526                	mv	a0,s1
    80002f72:	86cff0ef          	jal	80001fde <bwrite>
    if(recovering == 0)
    80002f76:	fa0b18e3          	bnez	s6,80002f26 <install_trans+0x36>
      bunpin(dbuf);
    80002f7a:	8526                	mv	a0,s1
    80002f7c:	950ff0ef          	jal	800020cc <bunpin>
    80002f80:	b75d                	j	80002f26 <install_trans+0x36>
}
    80002f82:	70e2                	ld	ra,56(sp)
    80002f84:	7442                	ld	s0,48(sp)
    80002f86:	74a2                	ld	s1,40(sp)
    80002f88:	7902                	ld	s2,32(sp)
    80002f8a:	69e2                	ld	s3,24(sp)
    80002f8c:	6a42                	ld	s4,16(sp)
    80002f8e:	6aa2                	ld	s5,8(sp)
    80002f90:	6b02                	ld	s6,0(sp)
    80002f92:	6121                	addi	sp,sp,64
    80002f94:	8082                	ret
    80002f96:	8082                	ret

0000000080002f98 <initlog>:
{
    80002f98:	7179                	addi	sp,sp,-48
    80002f9a:	f406                	sd	ra,40(sp)
    80002f9c:	f022                	sd	s0,32(sp)
    80002f9e:	ec26                	sd	s1,24(sp)
    80002fa0:	e84a                	sd	s2,16(sp)
    80002fa2:	e44e                	sd	s3,8(sp)
    80002fa4:	1800                	addi	s0,sp,48
    80002fa6:	892a                	mv	s2,a0
    80002fa8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002faa:	00012497          	auipc	s1,0x12
    80002fae:	71648493          	addi	s1,s1,1814 # 800156c0 <log>
    80002fb2:	00004597          	auipc	a1,0x4
    80002fb6:	54658593          	addi	a1,a1,1350 # 800074f8 <etext+0x4f8>
    80002fba:	8526                	mv	a0,s1
    80002fbc:	185020ef          	jal	80005940 <initlock>
  log.start = sb->logstart;
    80002fc0:	0149a583          	lw	a1,20(s3)
    80002fc4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002fc6:	0109a783          	lw	a5,16(s3)
    80002fca:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002fcc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002fd0:	854a                	mv	a0,s2
    80002fd2:	f37fe0ef          	jal	80001f08 <bread>
  log.lh.n = lh->n;
    80002fd6:	4d30                	lw	a2,88(a0)
    80002fd8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fda:	00c05f63          	blez	a2,80002ff8 <initlog+0x60>
    80002fde:	87aa                	mv	a5,a0
    80002fe0:	00012717          	auipc	a4,0x12
    80002fe4:	71070713          	addi	a4,a4,1808 # 800156f0 <log+0x30>
    80002fe8:	060a                	slli	a2,a2,0x2
    80002fea:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002fec:	4ff4                	lw	a3,92(a5)
    80002fee:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002ff0:	0791                	addi	a5,a5,4
    80002ff2:	0711                	addi	a4,a4,4
    80002ff4:	fec79ce3          	bne	a5,a2,80002fec <initlog+0x54>
  brelse(buf);
    80002ff8:	818ff0ef          	jal	80002010 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002ffc:	4505                	li	a0,1
    80002ffe:	ef3ff0ef          	jal	80002ef0 <install_trans>
  log.lh.n = 0;
    80003002:	00012797          	auipc	a5,0x12
    80003006:	6e07a523          	sw	zero,1770(a5) # 800156ec <log+0x2c>
  write_head(); // clear the log
    8000300a:	e89ff0ef          	jal	80002e92 <write_head>
}
    8000300e:	70a2                	ld	ra,40(sp)
    80003010:	7402                	ld	s0,32(sp)
    80003012:	64e2                	ld	s1,24(sp)
    80003014:	6942                	ld	s2,16(sp)
    80003016:	69a2                	ld	s3,8(sp)
    80003018:	6145                	addi	sp,sp,48
    8000301a:	8082                	ret

000000008000301c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000301c:	1101                	addi	sp,sp,-32
    8000301e:	ec06                	sd	ra,24(sp)
    80003020:	e822                	sd	s0,16(sp)
    80003022:	e426                	sd	s1,8(sp)
    80003024:	e04a                	sd	s2,0(sp)
    80003026:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003028:	00012517          	auipc	a0,0x12
    8000302c:	69850513          	addi	a0,a0,1688 # 800156c0 <log>
    80003030:	191020ef          	jal	800059c0 <acquire>
  while(1){
    if(log.committing){
    80003034:	00012497          	auipc	s1,0x12
    80003038:	68c48493          	addi	s1,s1,1676 # 800156c0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000303c:	4979                	li	s2,30
    8000303e:	a029                	j	80003048 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003040:	85a6                	mv	a1,s1
    80003042:	8526                	mv	a0,s1
    80003044:	af0fe0ef          	jal	80001334 <sleep>
    if(log.committing){
    80003048:	50dc                	lw	a5,36(s1)
    8000304a:	fbfd                	bnez	a5,80003040 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000304c:	5098                	lw	a4,32(s1)
    8000304e:	2705                	addiw	a4,a4,1
    80003050:	0027179b          	slliw	a5,a4,0x2
    80003054:	9fb9                	addw	a5,a5,a4
    80003056:	0017979b          	slliw	a5,a5,0x1
    8000305a:	54d4                	lw	a3,44(s1)
    8000305c:	9fb5                	addw	a5,a5,a3
    8000305e:	00f95763          	bge	s2,a5,8000306c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003062:	85a6                	mv	a1,s1
    80003064:	8526                	mv	a0,s1
    80003066:	acefe0ef          	jal	80001334 <sleep>
    8000306a:	bff9                	j	80003048 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000306c:	00012517          	auipc	a0,0x12
    80003070:	65450513          	addi	a0,a0,1620 # 800156c0 <log>
    80003074:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003076:	1e3020ef          	jal	80005a58 <release>
      break;
    }
  }
}
    8000307a:	60e2                	ld	ra,24(sp)
    8000307c:	6442                	ld	s0,16(sp)
    8000307e:	64a2                	ld	s1,8(sp)
    80003080:	6902                	ld	s2,0(sp)
    80003082:	6105                	addi	sp,sp,32
    80003084:	8082                	ret

0000000080003086 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003086:	7139                	addi	sp,sp,-64
    80003088:	fc06                	sd	ra,56(sp)
    8000308a:	f822                	sd	s0,48(sp)
    8000308c:	f426                	sd	s1,40(sp)
    8000308e:	f04a                	sd	s2,32(sp)
    80003090:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003092:	00012497          	auipc	s1,0x12
    80003096:	62e48493          	addi	s1,s1,1582 # 800156c0 <log>
    8000309a:	8526                	mv	a0,s1
    8000309c:	125020ef          	jal	800059c0 <acquire>
  log.outstanding -= 1;
    800030a0:	509c                	lw	a5,32(s1)
    800030a2:	37fd                	addiw	a5,a5,-1
    800030a4:	0007891b          	sext.w	s2,a5
    800030a8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800030aa:	50dc                	lw	a5,36(s1)
    800030ac:	ef9d                	bnez	a5,800030ea <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800030ae:	04091763          	bnez	s2,800030fc <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800030b2:	00012497          	auipc	s1,0x12
    800030b6:	60e48493          	addi	s1,s1,1550 # 800156c0 <log>
    800030ba:	4785                	li	a5,1
    800030bc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800030be:	8526                	mv	a0,s1
    800030c0:	199020ef          	jal	80005a58 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800030c4:	54dc                	lw	a5,44(s1)
    800030c6:	04f04b63          	bgtz	a5,8000311c <end_op+0x96>
    acquire(&log.lock);
    800030ca:	00012497          	auipc	s1,0x12
    800030ce:	5f648493          	addi	s1,s1,1526 # 800156c0 <log>
    800030d2:	8526                	mv	a0,s1
    800030d4:	0ed020ef          	jal	800059c0 <acquire>
    log.committing = 0;
    800030d8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030dc:	8526                	mv	a0,s1
    800030de:	aa2fe0ef          	jal	80001380 <wakeup>
    release(&log.lock);
    800030e2:	8526                	mv	a0,s1
    800030e4:	175020ef          	jal	80005a58 <release>
}
    800030e8:	a025                	j	80003110 <end_op+0x8a>
    800030ea:	ec4e                	sd	s3,24(sp)
    800030ec:	e852                	sd	s4,16(sp)
    800030ee:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800030f0:	00004517          	auipc	a0,0x4
    800030f4:	41050513          	addi	a0,a0,1040 # 80007500 <etext+0x500>
    800030f8:	59a020ef          	jal	80005692 <panic>
    wakeup(&log);
    800030fc:	00012497          	auipc	s1,0x12
    80003100:	5c448493          	addi	s1,s1,1476 # 800156c0 <log>
    80003104:	8526                	mv	a0,s1
    80003106:	a7afe0ef          	jal	80001380 <wakeup>
  release(&log.lock);
    8000310a:	8526                	mv	a0,s1
    8000310c:	14d020ef          	jal	80005a58 <release>
}
    80003110:	70e2                	ld	ra,56(sp)
    80003112:	7442                	ld	s0,48(sp)
    80003114:	74a2                	ld	s1,40(sp)
    80003116:	7902                	ld	s2,32(sp)
    80003118:	6121                	addi	sp,sp,64
    8000311a:	8082                	ret
    8000311c:	ec4e                	sd	s3,24(sp)
    8000311e:	e852                	sd	s4,16(sp)
    80003120:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003122:	00012a97          	auipc	s5,0x12
    80003126:	5cea8a93          	addi	s5,s5,1486 # 800156f0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000312a:	00012a17          	auipc	s4,0x12
    8000312e:	596a0a13          	addi	s4,s4,1430 # 800156c0 <log>
    80003132:	018a2583          	lw	a1,24(s4)
    80003136:	012585bb          	addw	a1,a1,s2
    8000313a:	2585                	addiw	a1,a1,1
    8000313c:	028a2503          	lw	a0,40(s4)
    80003140:	dc9fe0ef          	jal	80001f08 <bread>
    80003144:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003146:	000aa583          	lw	a1,0(s5)
    8000314a:	028a2503          	lw	a0,40(s4)
    8000314e:	dbbfe0ef          	jal	80001f08 <bread>
    80003152:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003154:	40000613          	li	a2,1024
    80003158:	05850593          	addi	a1,a0,88
    8000315c:	05848513          	addi	a0,s1,88
    80003160:	84afd0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    80003164:	8526                	mv	a0,s1
    80003166:	e79fe0ef          	jal	80001fde <bwrite>
    brelse(from);
    8000316a:	854e                	mv	a0,s3
    8000316c:	ea5fe0ef          	jal	80002010 <brelse>
    brelse(to);
    80003170:	8526                	mv	a0,s1
    80003172:	e9ffe0ef          	jal	80002010 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003176:	2905                	addiw	s2,s2,1
    80003178:	0a91                	addi	s5,s5,4
    8000317a:	02ca2783          	lw	a5,44(s4)
    8000317e:	faf94ae3          	blt	s2,a5,80003132 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003182:	d11ff0ef          	jal	80002e92 <write_head>
    install_trans(0); // Now install writes to home locations
    80003186:	4501                	li	a0,0
    80003188:	d69ff0ef          	jal	80002ef0 <install_trans>
    log.lh.n = 0;
    8000318c:	00012797          	auipc	a5,0x12
    80003190:	5607a023          	sw	zero,1376(a5) # 800156ec <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003194:	cffff0ef          	jal	80002e92 <write_head>
    80003198:	69e2                	ld	s3,24(sp)
    8000319a:	6a42                	ld	s4,16(sp)
    8000319c:	6aa2                	ld	s5,8(sp)
    8000319e:	b735                	j	800030ca <end_op+0x44>

00000000800031a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800031a0:	1101                	addi	sp,sp,-32
    800031a2:	ec06                	sd	ra,24(sp)
    800031a4:	e822                	sd	s0,16(sp)
    800031a6:	e426                	sd	s1,8(sp)
    800031a8:	e04a                	sd	s2,0(sp)
    800031aa:	1000                	addi	s0,sp,32
    800031ac:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800031ae:	00012917          	auipc	s2,0x12
    800031b2:	51290913          	addi	s2,s2,1298 # 800156c0 <log>
    800031b6:	854a                	mv	a0,s2
    800031b8:	009020ef          	jal	800059c0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800031bc:	02c92603          	lw	a2,44(s2)
    800031c0:	47f5                	li	a5,29
    800031c2:	06c7c363          	blt	a5,a2,80003228 <log_write+0x88>
    800031c6:	00012797          	auipc	a5,0x12
    800031ca:	5167a783          	lw	a5,1302(a5) # 800156dc <log+0x1c>
    800031ce:	37fd                	addiw	a5,a5,-1
    800031d0:	04f65c63          	bge	a2,a5,80003228 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031d4:	00012797          	auipc	a5,0x12
    800031d8:	50c7a783          	lw	a5,1292(a5) # 800156e0 <log+0x20>
    800031dc:	04f05c63          	blez	a5,80003234 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031e0:	4781                	li	a5,0
    800031e2:	04c05f63          	blez	a2,80003240 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031e6:	44cc                	lw	a1,12(s1)
    800031e8:	00012717          	auipc	a4,0x12
    800031ec:	50870713          	addi	a4,a4,1288 # 800156f0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031f0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031f2:	4314                	lw	a3,0(a4)
    800031f4:	04b68663          	beq	a3,a1,80003240 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031f8:	2785                	addiw	a5,a5,1
    800031fa:	0711                	addi	a4,a4,4
    800031fc:	fef61be3          	bne	a2,a5,800031f2 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003200:	0621                	addi	a2,a2,8
    80003202:	060a                	slli	a2,a2,0x2
    80003204:	00012797          	auipc	a5,0x12
    80003208:	4bc78793          	addi	a5,a5,1212 # 800156c0 <log>
    8000320c:	97b2                	add	a5,a5,a2
    8000320e:	44d8                	lw	a4,12(s1)
    80003210:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003212:	8526                	mv	a0,s1
    80003214:	e85fe0ef          	jal	80002098 <bpin>
    log.lh.n++;
    80003218:	00012717          	auipc	a4,0x12
    8000321c:	4a870713          	addi	a4,a4,1192 # 800156c0 <log>
    80003220:	575c                	lw	a5,44(a4)
    80003222:	2785                	addiw	a5,a5,1
    80003224:	d75c                	sw	a5,44(a4)
    80003226:	a80d                	j	80003258 <log_write+0xb8>
    panic("too big a transaction");
    80003228:	00004517          	auipc	a0,0x4
    8000322c:	2e850513          	addi	a0,a0,744 # 80007510 <etext+0x510>
    80003230:	462020ef          	jal	80005692 <panic>
    panic("log_write outside of trans");
    80003234:	00004517          	auipc	a0,0x4
    80003238:	2f450513          	addi	a0,a0,756 # 80007528 <etext+0x528>
    8000323c:	456020ef          	jal	80005692 <panic>
  log.lh.block[i] = b->blockno;
    80003240:	00878693          	addi	a3,a5,8
    80003244:	068a                	slli	a3,a3,0x2
    80003246:	00012717          	auipc	a4,0x12
    8000324a:	47a70713          	addi	a4,a4,1146 # 800156c0 <log>
    8000324e:	9736                	add	a4,a4,a3
    80003250:	44d4                	lw	a3,12(s1)
    80003252:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003254:	faf60fe3          	beq	a2,a5,80003212 <log_write+0x72>
  }
  release(&log.lock);
    80003258:	00012517          	auipc	a0,0x12
    8000325c:	46850513          	addi	a0,a0,1128 # 800156c0 <log>
    80003260:	7f8020ef          	jal	80005a58 <release>
}
    80003264:	60e2                	ld	ra,24(sp)
    80003266:	6442                	ld	s0,16(sp)
    80003268:	64a2                	ld	s1,8(sp)
    8000326a:	6902                	ld	s2,0(sp)
    8000326c:	6105                	addi	sp,sp,32
    8000326e:	8082                	ret

0000000080003270 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003270:	1101                	addi	sp,sp,-32
    80003272:	ec06                	sd	ra,24(sp)
    80003274:	e822                	sd	s0,16(sp)
    80003276:	e426                	sd	s1,8(sp)
    80003278:	e04a                	sd	s2,0(sp)
    8000327a:	1000                	addi	s0,sp,32
    8000327c:	84aa                	mv	s1,a0
    8000327e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003280:	00004597          	auipc	a1,0x4
    80003284:	2c858593          	addi	a1,a1,712 # 80007548 <etext+0x548>
    80003288:	0521                	addi	a0,a0,8
    8000328a:	6b6020ef          	jal	80005940 <initlock>
  lk->name = name;
    8000328e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003292:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003296:	0204a423          	sw	zero,40(s1)
}
    8000329a:	60e2                	ld	ra,24(sp)
    8000329c:	6442                	ld	s0,16(sp)
    8000329e:	64a2                	ld	s1,8(sp)
    800032a0:	6902                	ld	s2,0(sp)
    800032a2:	6105                	addi	sp,sp,32
    800032a4:	8082                	ret

00000000800032a6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800032a6:	1101                	addi	sp,sp,-32
    800032a8:	ec06                	sd	ra,24(sp)
    800032aa:	e822                	sd	s0,16(sp)
    800032ac:	e426                	sd	s1,8(sp)
    800032ae:	e04a                	sd	s2,0(sp)
    800032b0:	1000                	addi	s0,sp,32
    800032b2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032b4:	00850913          	addi	s2,a0,8
    800032b8:	854a                	mv	a0,s2
    800032ba:	706020ef          	jal	800059c0 <acquire>
  while (lk->locked) {
    800032be:	409c                	lw	a5,0(s1)
    800032c0:	c799                	beqz	a5,800032ce <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800032c2:	85ca                	mv	a1,s2
    800032c4:	8526                	mv	a0,s1
    800032c6:	86efe0ef          	jal	80001334 <sleep>
  while (lk->locked) {
    800032ca:	409c                	lw	a5,0(s1)
    800032cc:	fbfd                	bnez	a5,800032c2 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032ce:	4785                	li	a5,1
    800032d0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032d2:	a95fd0ef          	jal	80000d66 <myproc>
    800032d6:	591c                	lw	a5,48(a0)
    800032d8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032da:	854a                	mv	a0,s2
    800032dc:	77c020ef          	jal	80005a58 <release>
}
    800032e0:	60e2                	ld	ra,24(sp)
    800032e2:	6442                	ld	s0,16(sp)
    800032e4:	64a2                	ld	s1,8(sp)
    800032e6:	6902                	ld	s2,0(sp)
    800032e8:	6105                	addi	sp,sp,32
    800032ea:	8082                	ret

00000000800032ec <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032ec:	1101                	addi	sp,sp,-32
    800032ee:	ec06                	sd	ra,24(sp)
    800032f0:	e822                	sd	s0,16(sp)
    800032f2:	e426                	sd	s1,8(sp)
    800032f4:	e04a                	sd	s2,0(sp)
    800032f6:	1000                	addi	s0,sp,32
    800032f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032fa:	00850913          	addi	s2,a0,8
    800032fe:	854a                	mv	a0,s2
    80003300:	6c0020ef          	jal	800059c0 <acquire>
  lk->locked = 0;
    80003304:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003308:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000330c:	8526                	mv	a0,s1
    8000330e:	872fe0ef          	jal	80001380 <wakeup>
  release(&lk->lk);
    80003312:	854a                	mv	a0,s2
    80003314:	744020ef          	jal	80005a58 <release>
}
    80003318:	60e2                	ld	ra,24(sp)
    8000331a:	6442                	ld	s0,16(sp)
    8000331c:	64a2                	ld	s1,8(sp)
    8000331e:	6902                	ld	s2,0(sp)
    80003320:	6105                	addi	sp,sp,32
    80003322:	8082                	ret

0000000080003324 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003324:	7179                	addi	sp,sp,-48
    80003326:	f406                	sd	ra,40(sp)
    80003328:	f022                	sd	s0,32(sp)
    8000332a:	ec26                	sd	s1,24(sp)
    8000332c:	e84a                	sd	s2,16(sp)
    8000332e:	1800                	addi	s0,sp,48
    80003330:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003332:	00850913          	addi	s2,a0,8
    80003336:	854a                	mv	a0,s2
    80003338:	688020ef          	jal	800059c0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000333c:	409c                	lw	a5,0(s1)
    8000333e:	ef81                	bnez	a5,80003356 <holdingsleep+0x32>
    80003340:	4481                	li	s1,0
  release(&lk->lk);
    80003342:	854a                	mv	a0,s2
    80003344:	714020ef          	jal	80005a58 <release>
  return r;
}
    80003348:	8526                	mv	a0,s1
    8000334a:	70a2                	ld	ra,40(sp)
    8000334c:	7402                	ld	s0,32(sp)
    8000334e:	64e2                	ld	s1,24(sp)
    80003350:	6942                	ld	s2,16(sp)
    80003352:	6145                	addi	sp,sp,48
    80003354:	8082                	ret
    80003356:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003358:	0284a983          	lw	s3,40(s1)
    8000335c:	a0bfd0ef          	jal	80000d66 <myproc>
    80003360:	5904                	lw	s1,48(a0)
    80003362:	413484b3          	sub	s1,s1,s3
    80003366:	0014b493          	seqz	s1,s1
    8000336a:	69a2                	ld	s3,8(sp)
    8000336c:	bfd9                	j	80003342 <holdingsleep+0x1e>

000000008000336e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000336e:	1141                	addi	sp,sp,-16
    80003370:	e406                	sd	ra,8(sp)
    80003372:	e022                	sd	s0,0(sp)
    80003374:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003376:	00004597          	auipc	a1,0x4
    8000337a:	1e258593          	addi	a1,a1,482 # 80007558 <etext+0x558>
    8000337e:	00012517          	auipc	a0,0x12
    80003382:	48a50513          	addi	a0,a0,1162 # 80015808 <ftable>
    80003386:	5ba020ef          	jal	80005940 <initlock>
}
    8000338a:	60a2                	ld	ra,8(sp)
    8000338c:	6402                	ld	s0,0(sp)
    8000338e:	0141                	addi	sp,sp,16
    80003390:	8082                	ret

0000000080003392 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003392:	1101                	addi	sp,sp,-32
    80003394:	ec06                	sd	ra,24(sp)
    80003396:	e822                	sd	s0,16(sp)
    80003398:	e426                	sd	s1,8(sp)
    8000339a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000339c:	00012517          	auipc	a0,0x12
    800033a0:	46c50513          	addi	a0,a0,1132 # 80015808 <ftable>
    800033a4:	61c020ef          	jal	800059c0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033a8:	00012497          	auipc	s1,0x12
    800033ac:	47848493          	addi	s1,s1,1144 # 80015820 <ftable+0x18>
    800033b0:	00013717          	auipc	a4,0x13
    800033b4:	41070713          	addi	a4,a4,1040 # 800167c0 <disk>
    if(f->ref == 0){
    800033b8:	40dc                	lw	a5,4(s1)
    800033ba:	cf89                	beqz	a5,800033d4 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033bc:	02848493          	addi	s1,s1,40
    800033c0:	fee49ce3          	bne	s1,a4,800033b8 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800033c4:	00012517          	auipc	a0,0x12
    800033c8:	44450513          	addi	a0,a0,1092 # 80015808 <ftable>
    800033cc:	68c020ef          	jal	80005a58 <release>
  return 0;
    800033d0:	4481                	li	s1,0
    800033d2:	a809                	j	800033e4 <filealloc+0x52>
      f->ref = 1;
    800033d4:	4785                	li	a5,1
    800033d6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033d8:	00012517          	auipc	a0,0x12
    800033dc:	43050513          	addi	a0,a0,1072 # 80015808 <ftable>
    800033e0:	678020ef          	jal	80005a58 <release>
}
    800033e4:	8526                	mv	a0,s1
    800033e6:	60e2                	ld	ra,24(sp)
    800033e8:	6442                	ld	s0,16(sp)
    800033ea:	64a2                	ld	s1,8(sp)
    800033ec:	6105                	addi	sp,sp,32
    800033ee:	8082                	ret

00000000800033f0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033f0:	1101                	addi	sp,sp,-32
    800033f2:	ec06                	sd	ra,24(sp)
    800033f4:	e822                	sd	s0,16(sp)
    800033f6:	e426                	sd	s1,8(sp)
    800033f8:	1000                	addi	s0,sp,32
    800033fa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033fc:	00012517          	auipc	a0,0x12
    80003400:	40c50513          	addi	a0,a0,1036 # 80015808 <ftable>
    80003404:	5bc020ef          	jal	800059c0 <acquire>
  if(f->ref < 1)
    80003408:	40dc                	lw	a5,4(s1)
    8000340a:	02f05063          	blez	a5,8000342a <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000340e:	2785                	addiw	a5,a5,1
    80003410:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003412:	00012517          	auipc	a0,0x12
    80003416:	3f650513          	addi	a0,a0,1014 # 80015808 <ftable>
    8000341a:	63e020ef          	jal	80005a58 <release>
  return f;
}
    8000341e:	8526                	mv	a0,s1
    80003420:	60e2                	ld	ra,24(sp)
    80003422:	6442                	ld	s0,16(sp)
    80003424:	64a2                	ld	s1,8(sp)
    80003426:	6105                	addi	sp,sp,32
    80003428:	8082                	ret
    panic("filedup");
    8000342a:	00004517          	auipc	a0,0x4
    8000342e:	13650513          	addi	a0,a0,310 # 80007560 <etext+0x560>
    80003432:	260020ef          	jal	80005692 <panic>

0000000080003436 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003436:	7139                	addi	sp,sp,-64
    80003438:	fc06                	sd	ra,56(sp)
    8000343a:	f822                	sd	s0,48(sp)
    8000343c:	f426                	sd	s1,40(sp)
    8000343e:	0080                	addi	s0,sp,64
    80003440:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003442:	00012517          	auipc	a0,0x12
    80003446:	3c650513          	addi	a0,a0,966 # 80015808 <ftable>
    8000344a:	576020ef          	jal	800059c0 <acquire>
  if(f->ref < 1)
    8000344e:	40dc                	lw	a5,4(s1)
    80003450:	04f05a63          	blez	a5,800034a4 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003454:	37fd                	addiw	a5,a5,-1
    80003456:	0007871b          	sext.w	a4,a5
    8000345a:	c0dc                	sw	a5,4(s1)
    8000345c:	04e04e63          	bgtz	a4,800034b8 <fileclose+0x82>
    80003460:	f04a                	sd	s2,32(sp)
    80003462:	ec4e                	sd	s3,24(sp)
    80003464:	e852                	sd	s4,16(sp)
    80003466:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003468:	0004a903          	lw	s2,0(s1)
    8000346c:	0094ca83          	lbu	s5,9(s1)
    80003470:	0104ba03          	ld	s4,16(s1)
    80003474:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003478:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000347c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003480:	00012517          	auipc	a0,0x12
    80003484:	38850513          	addi	a0,a0,904 # 80015808 <ftable>
    80003488:	5d0020ef          	jal	80005a58 <release>

  if(ff.type == FD_PIPE){
    8000348c:	4785                	li	a5,1
    8000348e:	04f90063          	beq	s2,a5,800034ce <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003492:	3979                	addiw	s2,s2,-2
    80003494:	4785                	li	a5,1
    80003496:	0527f563          	bgeu	a5,s2,800034e0 <fileclose+0xaa>
    8000349a:	7902                	ld	s2,32(sp)
    8000349c:	69e2                	ld	s3,24(sp)
    8000349e:	6a42                	ld	s4,16(sp)
    800034a0:	6aa2                	ld	s5,8(sp)
    800034a2:	a00d                	j	800034c4 <fileclose+0x8e>
    800034a4:	f04a                	sd	s2,32(sp)
    800034a6:	ec4e                	sd	s3,24(sp)
    800034a8:	e852                	sd	s4,16(sp)
    800034aa:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800034ac:	00004517          	auipc	a0,0x4
    800034b0:	0bc50513          	addi	a0,a0,188 # 80007568 <etext+0x568>
    800034b4:	1de020ef          	jal	80005692 <panic>
    release(&ftable.lock);
    800034b8:	00012517          	auipc	a0,0x12
    800034bc:	35050513          	addi	a0,a0,848 # 80015808 <ftable>
    800034c0:	598020ef          	jal	80005a58 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800034c4:	70e2                	ld	ra,56(sp)
    800034c6:	7442                	ld	s0,48(sp)
    800034c8:	74a2                	ld	s1,40(sp)
    800034ca:	6121                	addi	sp,sp,64
    800034cc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034ce:	85d6                	mv	a1,s5
    800034d0:	8552                	mv	a0,s4
    800034d2:	336000ef          	jal	80003808 <pipeclose>
    800034d6:	7902                	ld	s2,32(sp)
    800034d8:	69e2                	ld	s3,24(sp)
    800034da:	6a42                	ld	s4,16(sp)
    800034dc:	6aa2                	ld	s5,8(sp)
    800034de:	b7dd                	j	800034c4 <fileclose+0x8e>
    begin_op();
    800034e0:	b3dff0ef          	jal	8000301c <begin_op>
    iput(ff.ip);
    800034e4:	854e                	mv	a0,s3
    800034e6:	c20ff0ef          	jal	80002906 <iput>
    end_op();
    800034ea:	b9dff0ef          	jal	80003086 <end_op>
    800034ee:	7902                	ld	s2,32(sp)
    800034f0:	69e2                	ld	s3,24(sp)
    800034f2:	6a42                	ld	s4,16(sp)
    800034f4:	6aa2                	ld	s5,8(sp)
    800034f6:	b7f9                	j	800034c4 <fileclose+0x8e>

00000000800034f8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034f8:	715d                	addi	sp,sp,-80
    800034fa:	e486                	sd	ra,72(sp)
    800034fc:	e0a2                	sd	s0,64(sp)
    800034fe:	fc26                	sd	s1,56(sp)
    80003500:	f44e                	sd	s3,40(sp)
    80003502:	0880                	addi	s0,sp,80
    80003504:	84aa                	mv	s1,a0
    80003506:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003508:	85ffd0ef          	jal	80000d66 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000350c:	409c                	lw	a5,0(s1)
    8000350e:	37f9                	addiw	a5,a5,-2
    80003510:	4705                	li	a4,1
    80003512:	04f76063          	bltu	a4,a5,80003552 <filestat+0x5a>
    80003516:	f84a                	sd	s2,48(sp)
    80003518:	892a                	mv	s2,a0
    ilock(f->ip);
    8000351a:	6c88                	ld	a0,24(s1)
    8000351c:	9d2ff0ef          	jal	800026ee <ilock>
    stati(f->ip, &st);
    80003520:	fb840593          	addi	a1,s0,-72
    80003524:	6c88                	ld	a0,24(s1)
    80003526:	c88ff0ef          	jal	800029ae <stati>
    iunlock(f->ip);
    8000352a:	6c88                	ld	a0,24(s1)
    8000352c:	a70ff0ef          	jal	8000279c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003530:	46e1                	li	a3,24
    80003532:	fb840613          	addi	a2,s0,-72
    80003536:	85ce                	mv	a1,s3
    80003538:	05093503          	ld	a0,80(s2)
    8000353c:	c9cfd0ef          	jal	800009d8 <copyout>
    80003540:	41f5551b          	sraiw	a0,a0,0x1f
    80003544:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003546:	60a6                	ld	ra,72(sp)
    80003548:	6406                	ld	s0,64(sp)
    8000354a:	74e2                	ld	s1,56(sp)
    8000354c:	79a2                	ld	s3,40(sp)
    8000354e:	6161                	addi	sp,sp,80
    80003550:	8082                	ret
  return -1;
    80003552:	557d                	li	a0,-1
    80003554:	bfcd                	j	80003546 <filestat+0x4e>

0000000080003556 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003556:	7179                	addi	sp,sp,-48
    80003558:	f406                	sd	ra,40(sp)
    8000355a:	f022                	sd	s0,32(sp)
    8000355c:	e84a                	sd	s2,16(sp)
    8000355e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003560:	00854783          	lbu	a5,8(a0)
    80003564:	cfd1                	beqz	a5,80003600 <fileread+0xaa>
    80003566:	ec26                	sd	s1,24(sp)
    80003568:	e44e                	sd	s3,8(sp)
    8000356a:	84aa                	mv	s1,a0
    8000356c:	89ae                	mv	s3,a1
    8000356e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003570:	411c                	lw	a5,0(a0)
    80003572:	4705                	li	a4,1
    80003574:	04e78363          	beq	a5,a4,800035ba <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003578:	470d                	li	a4,3
    8000357a:	04e78763          	beq	a5,a4,800035c8 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000357e:	4709                	li	a4,2
    80003580:	06e79a63          	bne	a5,a4,800035f4 <fileread+0x9e>
    ilock(f->ip);
    80003584:	6d08                	ld	a0,24(a0)
    80003586:	968ff0ef          	jal	800026ee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000358a:	874a                	mv	a4,s2
    8000358c:	5094                	lw	a3,32(s1)
    8000358e:	864e                	mv	a2,s3
    80003590:	4585                	li	a1,1
    80003592:	6c88                	ld	a0,24(s1)
    80003594:	c44ff0ef          	jal	800029d8 <readi>
    80003598:	892a                	mv	s2,a0
    8000359a:	00a05563          	blez	a0,800035a4 <fileread+0x4e>
      f->off += r;
    8000359e:	509c                	lw	a5,32(s1)
    800035a0:	9fa9                	addw	a5,a5,a0
    800035a2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800035a4:	6c88                	ld	a0,24(s1)
    800035a6:	9f6ff0ef          	jal	8000279c <iunlock>
    800035aa:	64e2                	ld	s1,24(sp)
    800035ac:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800035ae:	854a                	mv	a0,s2
    800035b0:	70a2                	ld	ra,40(sp)
    800035b2:	7402                	ld	s0,32(sp)
    800035b4:	6942                	ld	s2,16(sp)
    800035b6:	6145                	addi	sp,sp,48
    800035b8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800035ba:	6908                	ld	a0,16(a0)
    800035bc:	388000ef          	jal	80003944 <piperead>
    800035c0:	892a                	mv	s2,a0
    800035c2:	64e2                	ld	s1,24(sp)
    800035c4:	69a2                	ld	s3,8(sp)
    800035c6:	b7e5                	j	800035ae <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800035c8:	02451783          	lh	a5,36(a0)
    800035cc:	03079693          	slli	a3,a5,0x30
    800035d0:	92c1                	srli	a3,a3,0x30
    800035d2:	4725                	li	a4,9
    800035d4:	02d76863          	bltu	a4,a3,80003604 <fileread+0xae>
    800035d8:	0792                	slli	a5,a5,0x4
    800035da:	00012717          	auipc	a4,0x12
    800035de:	18e70713          	addi	a4,a4,398 # 80015768 <devsw>
    800035e2:	97ba                	add	a5,a5,a4
    800035e4:	639c                	ld	a5,0(a5)
    800035e6:	c39d                	beqz	a5,8000360c <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035e8:	4505                	li	a0,1
    800035ea:	9782                	jalr	a5
    800035ec:	892a                	mv	s2,a0
    800035ee:	64e2                	ld	s1,24(sp)
    800035f0:	69a2                	ld	s3,8(sp)
    800035f2:	bf75                	j	800035ae <fileread+0x58>
    panic("fileread");
    800035f4:	00004517          	auipc	a0,0x4
    800035f8:	f8450513          	addi	a0,a0,-124 # 80007578 <etext+0x578>
    800035fc:	096020ef          	jal	80005692 <panic>
    return -1;
    80003600:	597d                	li	s2,-1
    80003602:	b775                	j	800035ae <fileread+0x58>
      return -1;
    80003604:	597d                	li	s2,-1
    80003606:	64e2                	ld	s1,24(sp)
    80003608:	69a2                	ld	s3,8(sp)
    8000360a:	b755                	j	800035ae <fileread+0x58>
    8000360c:	597d                	li	s2,-1
    8000360e:	64e2                	ld	s1,24(sp)
    80003610:	69a2                	ld	s3,8(sp)
    80003612:	bf71                	j	800035ae <fileread+0x58>

0000000080003614 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003614:	00954783          	lbu	a5,9(a0)
    80003618:	10078b63          	beqz	a5,8000372e <filewrite+0x11a>
{
    8000361c:	715d                	addi	sp,sp,-80
    8000361e:	e486                	sd	ra,72(sp)
    80003620:	e0a2                	sd	s0,64(sp)
    80003622:	f84a                	sd	s2,48(sp)
    80003624:	f052                	sd	s4,32(sp)
    80003626:	e85a                	sd	s6,16(sp)
    80003628:	0880                	addi	s0,sp,80
    8000362a:	892a                	mv	s2,a0
    8000362c:	8b2e                	mv	s6,a1
    8000362e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003630:	411c                	lw	a5,0(a0)
    80003632:	4705                	li	a4,1
    80003634:	02e78763          	beq	a5,a4,80003662 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003638:	470d                	li	a4,3
    8000363a:	02e78863          	beq	a5,a4,8000366a <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000363e:	4709                	li	a4,2
    80003640:	0ce79c63          	bne	a5,a4,80003718 <filewrite+0x104>
    80003644:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003646:	0ac05863          	blez	a2,800036f6 <filewrite+0xe2>
    8000364a:	fc26                	sd	s1,56(sp)
    8000364c:	ec56                	sd	s5,24(sp)
    8000364e:	e45e                	sd	s7,8(sp)
    80003650:	e062                	sd	s8,0(sp)
    int i = 0;
    80003652:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003654:	6b85                	lui	s7,0x1
    80003656:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000365a:	6c05                	lui	s8,0x1
    8000365c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003660:	a8b5                	j	800036dc <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003662:	6908                	ld	a0,16(a0)
    80003664:	1fc000ef          	jal	80003860 <pipewrite>
    80003668:	a04d                	j	8000370a <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000366a:	02451783          	lh	a5,36(a0)
    8000366e:	03079693          	slli	a3,a5,0x30
    80003672:	92c1                	srli	a3,a3,0x30
    80003674:	4725                	li	a4,9
    80003676:	0ad76e63          	bltu	a4,a3,80003732 <filewrite+0x11e>
    8000367a:	0792                	slli	a5,a5,0x4
    8000367c:	00012717          	auipc	a4,0x12
    80003680:	0ec70713          	addi	a4,a4,236 # 80015768 <devsw>
    80003684:	97ba                	add	a5,a5,a4
    80003686:	679c                	ld	a5,8(a5)
    80003688:	c7dd                	beqz	a5,80003736 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000368a:	4505                	li	a0,1
    8000368c:	9782                	jalr	a5
    8000368e:	a8b5                	j	8000370a <filewrite+0xf6>
      if(n1 > max)
    80003690:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003694:	989ff0ef          	jal	8000301c <begin_op>
      ilock(f->ip);
    80003698:	01893503          	ld	a0,24(s2)
    8000369c:	852ff0ef          	jal	800026ee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036a0:	8756                	mv	a4,s5
    800036a2:	02092683          	lw	a3,32(s2)
    800036a6:	01698633          	add	a2,s3,s6
    800036aa:	4585                	li	a1,1
    800036ac:	01893503          	ld	a0,24(s2)
    800036b0:	c24ff0ef          	jal	80002ad4 <writei>
    800036b4:	84aa                	mv	s1,a0
    800036b6:	00a05763          	blez	a0,800036c4 <filewrite+0xb0>
        f->off += r;
    800036ba:	02092783          	lw	a5,32(s2)
    800036be:	9fa9                	addw	a5,a5,a0
    800036c0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800036c4:	01893503          	ld	a0,24(s2)
    800036c8:	8d4ff0ef          	jal	8000279c <iunlock>
      end_op();
    800036cc:	9bbff0ef          	jal	80003086 <end_op>

      if(r != n1){
    800036d0:	029a9563          	bne	s5,s1,800036fa <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800036d4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800036d8:	0149da63          	bge	s3,s4,800036ec <filewrite+0xd8>
      int n1 = n - i;
    800036dc:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800036e0:	0004879b          	sext.w	a5,s1
    800036e4:	fafbd6e3          	bge	s7,a5,80003690 <filewrite+0x7c>
    800036e8:	84e2                	mv	s1,s8
    800036ea:	b75d                	j	80003690 <filewrite+0x7c>
    800036ec:	74e2                	ld	s1,56(sp)
    800036ee:	6ae2                	ld	s5,24(sp)
    800036f0:	6ba2                	ld	s7,8(sp)
    800036f2:	6c02                	ld	s8,0(sp)
    800036f4:	a039                	j	80003702 <filewrite+0xee>
    int i = 0;
    800036f6:	4981                	li	s3,0
    800036f8:	a029                	j	80003702 <filewrite+0xee>
    800036fa:	74e2                	ld	s1,56(sp)
    800036fc:	6ae2                	ld	s5,24(sp)
    800036fe:	6ba2                	ld	s7,8(sp)
    80003700:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003702:	033a1c63          	bne	s4,s3,8000373a <filewrite+0x126>
    80003706:	8552                	mv	a0,s4
    80003708:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000370a:	60a6                	ld	ra,72(sp)
    8000370c:	6406                	ld	s0,64(sp)
    8000370e:	7942                	ld	s2,48(sp)
    80003710:	7a02                	ld	s4,32(sp)
    80003712:	6b42                	ld	s6,16(sp)
    80003714:	6161                	addi	sp,sp,80
    80003716:	8082                	ret
    80003718:	fc26                	sd	s1,56(sp)
    8000371a:	f44e                	sd	s3,40(sp)
    8000371c:	ec56                	sd	s5,24(sp)
    8000371e:	e45e                	sd	s7,8(sp)
    80003720:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003722:	00004517          	auipc	a0,0x4
    80003726:	e6650513          	addi	a0,a0,-410 # 80007588 <etext+0x588>
    8000372a:	769010ef          	jal	80005692 <panic>
    return -1;
    8000372e:	557d                	li	a0,-1
}
    80003730:	8082                	ret
      return -1;
    80003732:	557d                	li	a0,-1
    80003734:	bfd9                	j	8000370a <filewrite+0xf6>
    80003736:	557d                	li	a0,-1
    80003738:	bfc9                	j	8000370a <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000373a:	557d                	li	a0,-1
    8000373c:	79a2                	ld	s3,40(sp)
    8000373e:	b7f1                	j	8000370a <filewrite+0xf6>

0000000080003740 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003740:	7179                	addi	sp,sp,-48
    80003742:	f406                	sd	ra,40(sp)
    80003744:	f022                	sd	s0,32(sp)
    80003746:	ec26                	sd	s1,24(sp)
    80003748:	e052                	sd	s4,0(sp)
    8000374a:	1800                	addi	s0,sp,48
    8000374c:	84aa                	mv	s1,a0
    8000374e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003750:	0005b023          	sd	zero,0(a1)
    80003754:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003758:	c3bff0ef          	jal	80003392 <filealloc>
    8000375c:	e088                	sd	a0,0(s1)
    8000375e:	c549                	beqz	a0,800037e8 <pipealloc+0xa8>
    80003760:	c33ff0ef          	jal	80003392 <filealloc>
    80003764:	00aa3023          	sd	a0,0(s4)
    80003768:	cd25                	beqz	a0,800037e0 <pipealloc+0xa0>
    8000376a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000376c:	993fc0ef          	jal	800000fe <kalloc>
    80003770:	892a                	mv	s2,a0
    80003772:	c12d                	beqz	a0,800037d4 <pipealloc+0x94>
    80003774:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003776:	4985                	li	s3,1
    80003778:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000377c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003780:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003784:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003788:	00004597          	auipc	a1,0x4
    8000378c:	e1058593          	addi	a1,a1,-496 # 80007598 <etext+0x598>
    80003790:	1b0020ef          	jal	80005940 <initlock>
  (*f0)->type = FD_PIPE;
    80003794:	609c                	ld	a5,0(s1)
    80003796:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000379a:	609c                	ld	a5,0(s1)
    8000379c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800037a0:	609c                	ld	a5,0(s1)
    800037a2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800037a6:	609c                	ld	a5,0(s1)
    800037a8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800037ac:	000a3783          	ld	a5,0(s4)
    800037b0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800037b4:	000a3783          	ld	a5,0(s4)
    800037b8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800037bc:	000a3783          	ld	a5,0(s4)
    800037c0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800037c4:	000a3783          	ld	a5,0(s4)
    800037c8:	0127b823          	sd	s2,16(a5)
  return 0;
    800037cc:	4501                	li	a0,0
    800037ce:	6942                	ld	s2,16(sp)
    800037d0:	69a2                	ld	s3,8(sp)
    800037d2:	a01d                	j	800037f8 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800037d4:	6088                	ld	a0,0(s1)
    800037d6:	c119                	beqz	a0,800037dc <pipealloc+0x9c>
    800037d8:	6942                	ld	s2,16(sp)
    800037da:	a029                	j	800037e4 <pipealloc+0xa4>
    800037dc:	6942                	ld	s2,16(sp)
    800037de:	a029                	j	800037e8 <pipealloc+0xa8>
    800037e0:	6088                	ld	a0,0(s1)
    800037e2:	c10d                	beqz	a0,80003804 <pipealloc+0xc4>
    fileclose(*f0);
    800037e4:	c53ff0ef          	jal	80003436 <fileclose>
  if(*f1)
    800037e8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800037ec:	557d                	li	a0,-1
  if(*f1)
    800037ee:	c789                	beqz	a5,800037f8 <pipealloc+0xb8>
    fileclose(*f1);
    800037f0:	853e                	mv	a0,a5
    800037f2:	c45ff0ef          	jal	80003436 <fileclose>
  return -1;
    800037f6:	557d                	li	a0,-1
}
    800037f8:	70a2                	ld	ra,40(sp)
    800037fa:	7402                	ld	s0,32(sp)
    800037fc:	64e2                	ld	s1,24(sp)
    800037fe:	6a02                	ld	s4,0(sp)
    80003800:	6145                	addi	sp,sp,48
    80003802:	8082                	ret
  return -1;
    80003804:	557d                	li	a0,-1
    80003806:	bfcd                	j	800037f8 <pipealloc+0xb8>

0000000080003808 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003808:	1101                	addi	sp,sp,-32
    8000380a:	ec06                	sd	ra,24(sp)
    8000380c:	e822                	sd	s0,16(sp)
    8000380e:	e426                	sd	s1,8(sp)
    80003810:	e04a                	sd	s2,0(sp)
    80003812:	1000                	addi	s0,sp,32
    80003814:	84aa                	mv	s1,a0
    80003816:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003818:	1a8020ef          	jal	800059c0 <acquire>
  if(writable){
    8000381c:	02090763          	beqz	s2,8000384a <pipeclose+0x42>
    pi->writeopen = 0;
    80003820:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003824:	21848513          	addi	a0,s1,536
    80003828:	b59fd0ef          	jal	80001380 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000382c:	2204b783          	ld	a5,544(s1)
    80003830:	e785                	bnez	a5,80003858 <pipeclose+0x50>
    release(&pi->lock);
    80003832:	8526                	mv	a0,s1
    80003834:	224020ef          	jal	80005a58 <release>
    kfree((char*)pi);
    80003838:	8526                	mv	a0,s1
    8000383a:	fe2fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000383e:	60e2                	ld	ra,24(sp)
    80003840:	6442                	ld	s0,16(sp)
    80003842:	64a2                	ld	s1,8(sp)
    80003844:	6902                	ld	s2,0(sp)
    80003846:	6105                	addi	sp,sp,32
    80003848:	8082                	ret
    pi->readopen = 0;
    8000384a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000384e:	21c48513          	addi	a0,s1,540
    80003852:	b2ffd0ef          	jal	80001380 <wakeup>
    80003856:	bfd9                	j	8000382c <pipeclose+0x24>
    release(&pi->lock);
    80003858:	8526                	mv	a0,s1
    8000385a:	1fe020ef          	jal	80005a58 <release>
}
    8000385e:	b7c5                	j	8000383e <pipeclose+0x36>

0000000080003860 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003860:	711d                	addi	sp,sp,-96
    80003862:	ec86                	sd	ra,88(sp)
    80003864:	e8a2                	sd	s0,80(sp)
    80003866:	e4a6                	sd	s1,72(sp)
    80003868:	e0ca                	sd	s2,64(sp)
    8000386a:	fc4e                	sd	s3,56(sp)
    8000386c:	f852                	sd	s4,48(sp)
    8000386e:	f456                	sd	s5,40(sp)
    80003870:	1080                	addi	s0,sp,96
    80003872:	84aa                	mv	s1,a0
    80003874:	8aae                	mv	s5,a1
    80003876:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003878:	ceefd0ef          	jal	80000d66 <myproc>
    8000387c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000387e:	8526                	mv	a0,s1
    80003880:	140020ef          	jal	800059c0 <acquire>
  while(i < n){
    80003884:	0b405a63          	blez	s4,80003938 <pipewrite+0xd8>
    80003888:	f05a                	sd	s6,32(sp)
    8000388a:	ec5e                	sd	s7,24(sp)
    8000388c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000388e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003890:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003892:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003896:	21c48b93          	addi	s7,s1,540
    8000389a:	a81d                	j	800038d0 <pipewrite+0x70>
      release(&pi->lock);
    8000389c:	8526                	mv	a0,s1
    8000389e:	1ba020ef          	jal	80005a58 <release>
      return -1;
    800038a2:	597d                	li	s2,-1
    800038a4:	7b02                	ld	s6,32(sp)
    800038a6:	6be2                	ld	s7,24(sp)
    800038a8:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800038aa:	854a                	mv	a0,s2
    800038ac:	60e6                	ld	ra,88(sp)
    800038ae:	6446                	ld	s0,80(sp)
    800038b0:	64a6                	ld	s1,72(sp)
    800038b2:	6906                	ld	s2,64(sp)
    800038b4:	79e2                	ld	s3,56(sp)
    800038b6:	7a42                	ld	s4,48(sp)
    800038b8:	7aa2                	ld	s5,40(sp)
    800038ba:	6125                	addi	sp,sp,96
    800038bc:	8082                	ret
      wakeup(&pi->nread);
    800038be:	8562                	mv	a0,s8
    800038c0:	ac1fd0ef          	jal	80001380 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800038c4:	85a6                	mv	a1,s1
    800038c6:	855e                	mv	a0,s7
    800038c8:	a6dfd0ef          	jal	80001334 <sleep>
  while(i < n){
    800038cc:	05495b63          	bge	s2,s4,80003922 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800038d0:	2204a783          	lw	a5,544(s1)
    800038d4:	d7e1                	beqz	a5,8000389c <pipewrite+0x3c>
    800038d6:	854e                	mv	a0,s3
    800038d8:	c8ffd0ef          	jal	80001566 <killed>
    800038dc:	f161                	bnez	a0,8000389c <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800038de:	2184a783          	lw	a5,536(s1)
    800038e2:	21c4a703          	lw	a4,540(s1)
    800038e6:	2007879b          	addiw	a5,a5,512
    800038ea:	fcf70ae3          	beq	a4,a5,800038be <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038ee:	4685                	li	a3,1
    800038f0:	01590633          	add	a2,s2,s5
    800038f4:	faf40593          	addi	a1,s0,-81
    800038f8:	0509b503          	ld	a0,80(s3)
    800038fc:	9b2fd0ef          	jal	80000aae <copyin>
    80003900:	03650e63          	beq	a0,s6,8000393c <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003904:	21c4a783          	lw	a5,540(s1)
    80003908:	0017871b          	addiw	a4,a5,1
    8000390c:	20e4ae23          	sw	a4,540(s1)
    80003910:	1ff7f793          	andi	a5,a5,511
    80003914:	97a6                	add	a5,a5,s1
    80003916:	faf44703          	lbu	a4,-81(s0)
    8000391a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000391e:	2905                	addiw	s2,s2,1
    80003920:	b775                	j	800038cc <pipewrite+0x6c>
    80003922:	7b02                	ld	s6,32(sp)
    80003924:	6be2                	ld	s7,24(sp)
    80003926:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003928:	21848513          	addi	a0,s1,536
    8000392c:	a55fd0ef          	jal	80001380 <wakeup>
  release(&pi->lock);
    80003930:	8526                	mv	a0,s1
    80003932:	126020ef          	jal	80005a58 <release>
  return i;
    80003936:	bf95                	j	800038aa <pipewrite+0x4a>
  int i = 0;
    80003938:	4901                	li	s2,0
    8000393a:	b7fd                	j	80003928 <pipewrite+0xc8>
    8000393c:	7b02                	ld	s6,32(sp)
    8000393e:	6be2                	ld	s7,24(sp)
    80003940:	6c42                	ld	s8,16(sp)
    80003942:	b7dd                	j	80003928 <pipewrite+0xc8>

0000000080003944 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003944:	715d                	addi	sp,sp,-80
    80003946:	e486                	sd	ra,72(sp)
    80003948:	e0a2                	sd	s0,64(sp)
    8000394a:	fc26                	sd	s1,56(sp)
    8000394c:	f84a                	sd	s2,48(sp)
    8000394e:	f44e                	sd	s3,40(sp)
    80003950:	f052                	sd	s4,32(sp)
    80003952:	ec56                	sd	s5,24(sp)
    80003954:	0880                	addi	s0,sp,80
    80003956:	84aa                	mv	s1,a0
    80003958:	892e                	mv	s2,a1
    8000395a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000395c:	c0afd0ef          	jal	80000d66 <myproc>
    80003960:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003962:	8526                	mv	a0,s1
    80003964:	05c020ef          	jal	800059c0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003968:	2184a703          	lw	a4,536(s1)
    8000396c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003970:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003974:	02f71563          	bne	a4,a5,8000399e <piperead+0x5a>
    80003978:	2244a783          	lw	a5,548(s1)
    8000397c:	cb85                	beqz	a5,800039ac <piperead+0x68>
    if(killed(pr)){
    8000397e:	8552                	mv	a0,s4
    80003980:	be7fd0ef          	jal	80001566 <killed>
    80003984:	ed19                	bnez	a0,800039a2 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003986:	85a6                	mv	a1,s1
    80003988:	854e                	mv	a0,s3
    8000398a:	9abfd0ef          	jal	80001334 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000398e:	2184a703          	lw	a4,536(s1)
    80003992:	21c4a783          	lw	a5,540(s1)
    80003996:	fef701e3          	beq	a4,a5,80003978 <piperead+0x34>
    8000399a:	e85a                	sd	s6,16(sp)
    8000399c:	a809                	j	800039ae <piperead+0x6a>
    8000399e:	e85a                	sd	s6,16(sp)
    800039a0:	a039                	j	800039ae <piperead+0x6a>
      release(&pi->lock);
    800039a2:	8526                	mv	a0,s1
    800039a4:	0b4020ef          	jal	80005a58 <release>
      return -1;
    800039a8:	59fd                	li	s3,-1
    800039aa:	a8b1                	j	80003a06 <piperead+0xc2>
    800039ac:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039ae:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039b0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039b2:	05505263          	blez	s5,800039f6 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800039b6:	2184a783          	lw	a5,536(s1)
    800039ba:	21c4a703          	lw	a4,540(s1)
    800039be:	02f70c63          	beq	a4,a5,800039f6 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800039c2:	0017871b          	addiw	a4,a5,1
    800039c6:	20e4ac23          	sw	a4,536(s1)
    800039ca:	1ff7f793          	andi	a5,a5,511
    800039ce:	97a6                	add	a5,a5,s1
    800039d0:	0187c783          	lbu	a5,24(a5)
    800039d4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039d8:	4685                	li	a3,1
    800039da:	fbf40613          	addi	a2,s0,-65
    800039de:	85ca                	mv	a1,s2
    800039e0:	050a3503          	ld	a0,80(s4)
    800039e4:	ff5fc0ef          	jal	800009d8 <copyout>
    800039e8:	01650763          	beq	a0,s6,800039f6 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039ec:	2985                	addiw	s3,s3,1
    800039ee:	0905                	addi	s2,s2,1
    800039f0:	fd3a93e3          	bne	s5,s3,800039b6 <piperead+0x72>
    800039f4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800039f6:	21c48513          	addi	a0,s1,540
    800039fa:	987fd0ef          	jal	80001380 <wakeup>
  release(&pi->lock);
    800039fe:	8526                	mv	a0,s1
    80003a00:	058020ef          	jal	80005a58 <release>
    80003a04:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a06:	854e                	mv	a0,s3
    80003a08:	60a6                	ld	ra,72(sp)
    80003a0a:	6406                	ld	s0,64(sp)
    80003a0c:	74e2                	ld	s1,56(sp)
    80003a0e:	7942                	ld	s2,48(sp)
    80003a10:	79a2                	ld	s3,40(sp)
    80003a12:	7a02                	ld	s4,32(sp)
    80003a14:	6ae2                	ld	s5,24(sp)
    80003a16:	6161                	addi	sp,sp,80
    80003a18:	8082                	ret

0000000080003a1a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a1a:	1141                	addi	sp,sp,-16
    80003a1c:	e422                	sd	s0,8(sp)
    80003a1e:	0800                	addi	s0,sp,16
    80003a20:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a22:	8905                	andi	a0,a0,1
    80003a24:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003a26:	8b89                	andi	a5,a5,2
    80003a28:	c399                	beqz	a5,80003a2e <flags2perm+0x14>
      perm |= PTE_W;
    80003a2a:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a2e:	6422                	ld	s0,8(sp)
    80003a30:	0141                	addi	sp,sp,16
    80003a32:	8082                	ret

0000000080003a34 <exec>:

int
exec(char *path, char **argv)
{
    80003a34:	df010113          	addi	sp,sp,-528
    80003a38:	20113423          	sd	ra,520(sp)
    80003a3c:	20813023          	sd	s0,512(sp)
    80003a40:	ffa6                	sd	s1,504(sp)
    80003a42:	fbca                	sd	s2,496(sp)
    80003a44:	0c00                	addi	s0,sp,528
    80003a46:	892a                	mv	s2,a0
    80003a48:	dea43c23          	sd	a0,-520(s0)
    80003a4c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a50:	b16fd0ef          	jal	80000d66 <myproc>
    80003a54:	84aa                	mv	s1,a0

  begin_op();
    80003a56:	dc6ff0ef          	jal	8000301c <begin_op>

  if((ip = namei(path)) == 0){
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	c04ff0ef          	jal	80002e60 <namei>
    80003a60:	c931                	beqz	a0,80003ab4 <exec+0x80>
    80003a62:	f3d2                	sd	s4,480(sp)
    80003a64:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a66:	c89fe0ef          	jal	800026ee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a6a:	04000713          	li	a4,64
    80003a6e:	4681                	li	a3,0
    80003a70:	e5040613          	addi	a2,s0,-432
    80003a74:	4581                	li	a1,0
    80003a76:	8552                	mv	a0,s4
    80003a78:	f61fe0ef          	jal	800029d8 <readi>
    80003a7c:	04000793          	li	a5,64
    80003a80:	00f51a63          	bne	a0,a5,80003a94 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a84:	e5042703          	lw	a4,-432(s0)
    80003a88:	464c47b7          	lui	a5,0x464c4
    80003a8c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003a90:	02f70663          	beq	a4,a5,80003abc <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003a94:	8552                	mv	a0,s4
    80003a96:	ef9fe0ef          	jal	8000298e <iunlockput>
    end_op();
    80003a9a:	decff0ef          	jal	80003086 <end_op>
  }
  return -1;
    80003a9e:	557d                	li	a0,-1
    80003aa0:	7a1e                	ld	s4,480(sp)
}
    80003aa2:	20813083          	ld	ra,520(sp)
    80003aa6:	20013403          	ld	s0,512(sp)
    80003aaa:	74fe                	ld	s1,504(sp)
    80003aac:	795e                	ld	s2,496(sp)
    80003aae:	21010113          	addi	sp,sp,528
    80003ab2:	8082                	ret
    end_op();
    80003ab4:	dd2ff0ef          	jal	80003086 <end_op>
    return -1;
    80003ab8:	557d                	li	a0,-1
    80003aba:	b7e5                	j	80003aa2 <exec+0x6e>
    80003abc:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003abe:	8526                	mv	a0,s1
    80003ac0:	b4efd0ef          	jal	80000e0e <proc_pagetable>
    80003ac4:	8b2a                	mv	s6,a0
    80003ac6:	2c050b63          	beqz	a0,80003d9c <exec+0x368>
    80003aca:	f7ce                	sd	s3,488(sp)
    80003acc:	efd6                	sd	s5,472(sp)
    80003ace:	e7de                	sd	s7,456(sp)
    80003ad0:	e3e2                	sd	s8,448(sp)
    80003ad2:	ff66                	sd	s9,440(sp)
    80003ad4:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ad6:	e7042d03          	lw	s10,-400(s0)
    80003ada:	e8845783          	lhu	a5,-376(s0)
    80003ade:	12078963          	beqz	a5,80003c10 <exec+0x1dc>
    80003ae2:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ae4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ae6:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003ae8:	6c85                	lui	s9,0x1
    80003aea:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003aee:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003af2:	6a85                	lui	s5,0x1
    80003af4:	a085                	j	80003b54 <exec+0x120>
      panic("loadseg: address should exist");
    80003af6:	00004517          	auipc	a0,0x4
    80003afa:	aaa50513          	addi	a0,a0,-1366 # 800075a0 <etext+0x5a0>
    80003afe:	395010ef          	jal	80005692 <panic>
    if(sz - i < PGSIZE)
    80003b02:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b04:	8726                	mv	a4,s1
    80003b06:	012c06bb          	addw	a3,s8,s2
    80003b0a:	4581                	li	a1,0
    80003b0c:	8552                	mv	a0,s4
    80003b0e:	ecbfe0ef          	jal	800029d8 <readi>
    80003b12:	2501                	sext.w	a0,a0
    80003b14:	24a49a63          	bne	s1,a0,80003d68 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003b18:	012a893b          	addw	s2,s5,s2
    80003b1c:	03397363          	bgeu	s2,s3,80003b42 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b20:	02091593          	slli	a1,s2,0x20
    80003b24:	9181                	srli	a1,a1,0x20
    80003b26:	95de                	add	a1,a1,s7
    80003b28:	855a                	mv	a0,s6
    80003b2a:	933fc0ef          	jal	8000045c <walkaddr>
    80003b2e:	862a                	mv	a2,a0
    if(pa == 0)
    80003b30:	d179                	beqz	a0,80003af6 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003b32:	412984bb          	subw	s1,s3,s2
    80003b36:	0004879b          	sext.w	a5,s1
    80003b3a:	fcfcf4e3          	bgeu	s9,a5,80003b02 <exec+0xce>
    80003b3e:	84d6                	mv	s1,s5
    80003b40:	b7c9                	j	80003b02 <exec+0xce>
    sz = sz1;
    80003b42:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b46:	2d85                	addiw	s11,s11,1
    80003b48:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003b4c:	e8845783          	lhu	a5,-376(s0)
    80003b50:	08fdd063          	bge	s11,a5,80003bd0 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b54:	2d01                	sext.w	s10,s10
    80003b56:	03800713          	li	a4,56
    80003b5a:	86ea                	mv	a3,s10
    80003b5c:	e1840613          	addi	a2,s0,-488
    80003b60:	4581                	li	a1,0
    80003b62:	8552                	mv	a0,s4
    80003b64:	e75fe0ef          	jal	800029d8 <readi>
    80003b68:	03800793          	li	a5,56
    80003b6c:	1cf51663          	bne	a0,a5,80003d38 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003b70:	e1842783          	lw	a5,-488(s0)
    80003b74:	4705                	li	a4,1
    80003b76:	fce798e3          	bne	a5,a4,80003b46 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003b7a:	e4043483          	ld	s1,-448(s0)
    80003b7e:	e3843783          	ld	a5,-456(s0)
    80003b82:	1af4ef63          	bltu	s1,a5,80003d40 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b86:	e2843783          	ld	a5,-472(s0)
    80003b8a:	94be                	add	s1,s1,a5
    80003b8c:	1af4ee63          	bltu	s1,a5,80003d48 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003b90:	df043703          	ld	a4,-528(s0)
    80003b94:	8ff9                	and	a5,a5,a4
    80003b96:	1a079d63          	bnez	a5,80003d50 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b9a:	e1c42503          	lw	a0,-484(s0)
    80003b9e:	e7dff0ef          	jal	80003a1a <flags2perm>
    80003ba2:	86aa                	mv	a3,a0
    80003ba4:	8626                	mv	a2,s1
    80003ba6:	85ca                	mv	a1,s2
    80003ba8:	855a                	mv	a0,s6
    80003baa:	c1bfc0ef          	jal	800007c4 <uvmalloc>
    80003bae:	e0a43423          	sd	a0,-504(s0)
    80003bb2:	1a050363          	beqz	a0,80003d58 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003bb6:	e2843b83          	ld	s7,-472(s0)
    80003bba:	e2042c03          	lw	s8,-480(s0)
    80003bbe:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003bc2:	00098463          	beqz	s3,80003bca <exec+0x196>
    80003bc6:	4901                	li	s2,0
    80003bc8:	bfa1                	j	80003b20 <exec+0xec>
    sz = sz1;
    80003bca:	e0843903          	ld	s2,-504(s0)
    80003bce:	bfa5                	j	80003b46 <exec+0x112>
    80003bd0:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003bd2:	8552                	mv	a0,s4
    80003bd4:	dbbfe0ef          	jal	8000298e <iunlockput>
  end_op();
    80003bd8:	caeff0ef          	jal	80003086 <end_op>
  p = myproc();
    80003bdc:	98afd0ef          	jal	80000d66 <myproc>
    80003be0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003be2:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003be6:	6985                	lui	s3,0x1
    80003be8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003bea:	99ca                	add	s3,s3,s2
    80003bec:	77fd                	lui	a5,0xfffff
    80003bee:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bf2:	4691                	li	a3,4
    80003bf4:	6609                	lui	a2,0x2
    80003bf6:	964e                	add	a2,a2,s3
    80003bf8:	85ce                	mv	a1,s3
    80003bfa:	855a                	mv	a0,s6
    80003bfc:	bc9fc0ef          	jal	800007c4 <uvmalloc>
    80003c00:	892a                	mv	s2,a0
    80003c02:	e0a43423          	sd	a0,-504(s0)
    80003c06:	e519                	bnez	a0,80003c14 <exec+0x1e0>
  if(pagetable)
    80003c08:	e1343423          	sd	s3,-504(s0)
    80003c0c:	4a01                	li	s4,0
    80003c0e:	aab1                	j	80003d6a <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c10:	4901                	li	s2,0
    80003c12:	b7c1                	j	80003bd2 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c14:	75f9                	lui	a1,0xffffe
    80003c16:	95aa                	add	a1,a1,a0
    80003c18:	855a                	mv	a0,s6
    80003c1a:	d95fc0ef          	jal	800009ae <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c1e:	7bfd                	lui	s7,0xfffff
    80003c20:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c22:	e0043783          	ld	a5,-512(s0)
    80003c26:	6388                	ld	a0,0(a5)
    80003c28:	cd39                	beqz	a0,80003c86 <exec+0x252>
    80003c2a:	e9040993          	addi	s3,s0,-368
    80003c2e:	f9040c13          	addi	s8,s0,-112
    80003c32:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c34:	e8afc0ef          	jal	800002be <strlen>
    80003c38:	0015079b          	addiw	a5,a0,1
    80003c3c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c40:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c44:	11796e63          	bltu	s2,s7,80003d60 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c48:	e0043d03          	ld	s10,-512(s0)
    80003c4c:	000d3a03          	ld	s4,0(s10)
    80003c50:	8552                	mv	a0,s4
    80003c52:	e6cfc0ef          	jal	800002be <strlen>
    80003c56:	0015069b          	addiw	a3,a0,1
    80003c5a:	8652                	mv	a2,s4
    80003c5c:	85ca                	mv	a1,s2
    80003c5e:	855a                	mv	a0,s6
    80003c60:	d79fc0ef          	jal	800009d8 <copyout>
    80003c64:	10054063          	bltz	a0,80003d64 <exec+0x330>
    ustack[argc] = sp;
    80003c68:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003c6c:	0485                	addi	s1,s1,1
    80003c6e:	008d0793          	addi	a5,s10,8
    80003c72:	e0f43023          	sd	a5,-512(s0)
    80003c76:	008d3503          	ld	a0,8(s10)
    80003c7a:	c909                	beqz	a0,80003c8c <exec+0x258>
    if(argc >= MAXARG)
    80003c7c:	09a1                	addi	s3,s3,8
    80003c7e:	fb899be3          	bne	s3,s8,80003c34 <exec+0x200>
  ip = 0;
    80003c82:	4a01                	li	s4,0
    80003c84:	a0dd                	j	80003d6a <exec+0x336>
  sp = sz;
    80003c86:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003c8a:	4481                	li	s1,0
  ustack[argc] = 0;
    80003c8c:	00349793          	slli	a5,s1,0x3
    80003c90:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffe0590>
    80003c94:	97a2                	add	a5,a5,s0
    80003c96:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003c9a:	00148693          	addi	a3,s1,1
    80003c9e:	068e                	slli	a3,a3,0x3
    80003ca0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003ca4:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003ca8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003cac:	f5796ee3          	bltu	s2,s7,80003c08 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003cb0:	e9040613          	addi	a2,s0,-368
    80003cb4:	85ca                	mv	a1,s2
    80003cb6:	855a                	mv	a0,s6
    80003cb8:	d21fc0ef          	jal	800009d8 <copyout>
    80003cbc:	0e054263          	bltz	a0,80003da0 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003cc0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003cc4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003cc8:	df843783          	ld	a5,-520(s0)
    80003ccc:	0007c703          	lbu	a4,0(a5)
    80003cd0:	cf11                	beqz	a4,80003cec <exec+0x2b8>
    80003cd2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003cd4:	02f00693          	li	a3,47
    80003cd8:	a039                	j	80003ce6 <exec+0x2b2>
      last = s+1;
    80003cda:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003cde:	0785                	addi	a5,a5,1
    80003ce0:	fff7c703          	lbu	a4,-1(a5)
    80003ce4:	c701                	beqz	a4,80003cec <exec+0x2b8>
    if(*s == '/')
    80003ce6:	fed71ce3          	bne	a4,a3,80003cde <exec+0x2aa>
    80003cea:	bfc5                	j	80003cda <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003cec:	4641                	li	a2,16
    80003cee:	df843583          	ld	a1,-520(s0)
    80003cf2:	158a8513          	addi	a0,s5,344
    80003cf6:	d96fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003cfa:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003cfe:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d02:	e0843783          	ld	a5,-504(s0)
    80003d06:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d0a:	058ab783          	ld	a5,88(s5)
    80003d0e:	e6843703          	ld	a4,-408(s0)
    80003d12:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d14:	058ab783          	ld	a5,88(s5)
    80003d18:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d1c:	85e6                	mv	a1,s9
    80003d1e:	974fd0ef          	jal	80000e92 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d22:	0004851b          	sext.w	a0,s1
    80003d26:	79be                	ld	s3,488(sp)
    80003d28:	7a1e                	ld	s4,480(sp)
    80003d2a:	6afe                	ld	s5,472(sp)
    80003d2c:	6b5e                	ld	s6,464(sp)
    80003d2e:	6bbe                	ld	s7,456(sp)
    80003d30:	6c1e                	ld	s8,448(sp)
    80003d32:	7cfa                	ld	s9,440(sp)
    80003d34:	7d5a                	ld	s10,432(sp)
    80003d36:	b3b5                	j	80003aa2 <exec+0x6e>
    80003d38:	e1243423          	sd	s2,-504(s0)
    80003d3c:	7dba                	ld	s11,424(sp)
    80003d3e:	a035                	j	80003d6a <exec+0x336>
    80003d40:	e1243423          	sd	s2,-504(s0)
    80003d44:	7dba                	ld	s11,424(sp)
    80003d46:	a015                	j	80003d6a <exec+0x336>
    80003d48:	e1243423          	sd	s2,-504(s0)
    80003d4c:	7dba                	ld	s11,424(sp)
    80003d4e:	a831                	j	80003d6a <exec+0x336>
    80003d50:	e1243423          	sd	s2,-504(s0)
    80003d54:	7dba                	ld	s11,424(sp)
    80003d56:	a811                	j	80003d6a <exec+0x336>
    80003d58:	e1243423          	sd	s2,-504(s0)
    80003d5c:	7dba                	ld	s11,424(sp)
    80003d5e:	a031                	j	80003d6a <exec+0x336>
  ip = 0;
    80003d60:	4a01                	li	s4,0
    80003d62:	a021                	j	80003d6a <exec+0x336>
    80003d64:	4a01                	li	s4,0
  if(pagetable)
    80003d66:	a011                	j	80003d6a <exec+0x336>
    80003d68:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003d6a:	e0843583          	ld	a1,-504(s0)
    80003d6e:	855a                	mv	a0,s6
    80003d70:	922fd0ef          	jal	80000e92 <proc_freepagetable>
  return -1;
    80003d74:	557d                	li	a0,-1
  if(ip){
    80003d76:	000a1b63          	bnez	s4,80003d8c <exec+0x358>
    80003d7a:	79be                	ld	s3,488(sp)
    80003d7c:	7a1e                	ld	s4,480(sp)
    80003d7e:	6afe                	ld	s5,472(sp)
    80003d80:	6b5e                	ld	s6,464(sp)
    80003d82:	6bbe                	ld	s7,456(sp)
    80003d84:	6c1e                	ld	s8,448(sp)
    80003d86:	7cfa                	ld	s9,440(sp)
    80003d88:	7d5a                	ld	s10,432(sp)
    80003d8a:	bb21                	j	80003aa2 <exec+0x6e>
    80003d8c:	79be                	ld	s3,488(sp)
    80003d8e:	6afe                	ld	s5,472(sp)
    80003d90:	6b5e                	ld	s6,464(sp)
    80003d92:	6bbe                	ld	s7,456(sp)
    80003d94:	6c1e                	ld	s8,448(sp)
    80003d96:	7cfa                	ld	s9,440(sp)
    80003d98:	7d5a                	ld	s10,432(sp)
    80003d9a:	b9ed                	j	80003a94 <exec+0x60>
    80003d9c:	6b5e                	ld	s6,464(sp)
    80003d9e:	b9dd                	j	80003a94 <exec+0x60>
  sz = sz1;
    80003da0:	e0843983          	ld	s3,-504(s0)
    80003da4:	b595                	j	80003c08 <exec+0x1d4>

0000000080003da6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003da6:	7179                	addi	sp,sp,-48
    80003da8:	f406                	sd	ra,40(sp)
    80003daa:	f022                	sd	s0,32(sp)
    80003dac:	ec26                	sd	s1,24(sp)
    80003dae:	e84a                	sd	s2,16(sp)
    80003db0:	1800                	addi	s0,sp,48
    80003db2:	892e                	mv	s2,a1
    80003db4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003db6:	fdc40593          	addi	a1,s0,-36
    80003dba:	e5bfd0ef          	jal	80001c14 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003dbe:	fdc42703          	lw	a4,-36(s0)
    80003dc2:	47bd                	li	a5,15
    80003dc4:	02e7e963          	bltu	a5,a4,80003df6 <argfd+0x50>
    80003dc8:	f9ffc0ef          	jal	80000d66 <myproc>
    80003dcc:	fdc42703          	lw	a4,-36(s0)
    80003dd0:	01a70793          	addi	a5,a4,26
    80003dd4:	078e                	slli	a5,a5,0x3
    80003dd6:	953e                	add	a0,a0,a5
    80003dd8:	611c                	ld	a5,0(a0)
    80003dda:	c385                	beqz	a5,80003dfa <argfd+0x54>
    return -1;
  if(pfd)
    80003ddc:	00090463          	beqz	s2,80003de4 <argfd+0x3e>
    *pfd = fd;
    80003de0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003de4:	4501                	li	a0,0
  if(pf)
    80003de6:	c091                	beqz	s1,80003dea <argfd+0x44>
    *pf = f;
    80003de8:	e09c                	sd	a5,0(s1)
}
    80003dea:	70a2                	ld	ra,40(sp)
    80003dec:	7402                	ld	s0,32(sp)
    80003dee:	64e2                	ld	s1,24(sp)
    80003df0:	6942                	ld	s2,16(sp)
    80003df2:	6145                	addi	sp,sp,48
    80003df4:	8082                	ret
    return -1;
    80003df6:	557d                	li	a0,-1
    80003df8:	bfcd                	j	80003dea <argfd+0x44>
    80003dfa:	557d                	li	a0,-1
    80003dfc:	b7fd                	j	80003dea <argfd+0x44>

0000000080003dfe <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003dfe:	1101                	addi	sp,sp,-32
    80003e00:	ec06                	sd	ra,24(sp)
    80003e02:	e822                	sd	s0,16(sp)
    80003e04:	e426                	sd	s1,8(sp)
    80003e06:	1000                	addi	s0,sp,32
    80003e08:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e0a:	f5dfc0ef          	jal	80000d66 <myproc>
    80003e0e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e10:	0d050793          	addi	a5,a0,208
    80003e14:	4501                	li	a0,0
    80003e16:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e18:	6398                	ld	a4,0(a5)
    80003e1a:	cb19                	beqz	a4,80003e30 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e1c:	2505                	addiw	a0,a0,1
    80003e1e:	07a1                	addi	a5,a5,8
    80003e20:	fed51ce3          	bne	a0,a3,80003e18 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e24:	557d                	li	a0,-1
}
    80003e26:	60e2                	ld	ra,24(sp)
    80003e28:	6442                	ld	s0,16(sp)
    80003e2a:	64a2                	ld	s1,8(sp)
    80003e2c:	6105                	addi	sp,sp,32
    80003e2e:	8082                	ret
      p->ofile[fd] = f;
    80003e30:	01a50793          	addi	a5,a0,26
    80003e34:	078e                	slli	a5,a5,0x3
    80003e36:	963e                	add	a2,a2,a5
    80003e38:	e204                	sd	s1,0(a2)
      return fd;
    80003e3a:	b7f5                	j	80003e26 <fdalloc+0x28>

0000000080003e3c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e3c:	715d                	addi	sp,sp,-80
    80003e3e:	e486                	sd	ra,72(sp)
    80003e40:	e0a2                	sd	s0,64(sp)
    80003e42:	fc26                	sd	s1,56(sp)
    80003e44:	f84a                	sd	s2,48(sp)
    80003e46:	f44e                	sd	s3,40(sp)
    80003e48:	ec56                	sd	s5,24(sp)
    80003e4a:	e85a                	sd	s6,16(sp)
    80003e4c:	0880                	addi	s0,sp,80
    80003e4e:	8b2e                	mv	s6,a1
    80003e50:	89b2                	mv	s3,a2
    80003e52:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e54:	fb040593          	addi	a1,s0,-80
    80003e58:	822ff0ef          	jal	80002e7a <nameiparent>
    80003e5c:	84aa                	mv	s1,a0
    80003e5e:	10050a63          	beqz	a0,80003f72 <create+0x136>
    return 0;

  ilock(dp);
    80003e62:	88dfe0ef          	jal	800026ee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e66:	4601                	li	a2,0
    80003e68:	fb040593          	addi	a1,s0,-80
    80003e6c:	8526                	mv	a0,s1
    80003e6e:	d8dfe0ef          	jal	80002bfa <dirlookup>
    80003e72:	8aaa                	mv	s5,a0
    80003e74:	c129                	beqz	a0,80003eb6 <create+0x7a>
    iunlockput(dp);
    80003e76:	8526                	mv	a0,s1
    80003e78:	b17fe0ef          	jal	8000298e <iunlockput>
    ilock(ip);
    80003e7c:	8556                	mv	a0,s5
    80003e7e:	871fe0ef          	jal	800026ee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e82:	4789                	li	a5,2
    80003e84:	02fb1463          	bne	s6,a5,80003eac <create+0x70>
    80003e88:	044ad783          	lhu	a5,68(s5)
    80003e8c:	37f9                	addiw	a5,a5,-2
    80003e8e:	17c2                	slli	a5,a5,0x30
    80003e90:	93c1                	srli	a5,a5,0x30
    80003e92:	4705                	li	a4,1
    80003e94:	00f76c63          	bltu	a4,a5,80003eac <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e98:	8556                	mv	a0,s5
    80003e9a:	60a6                	ld	ra,72(sp)
    80003e9c:	6406                	ld	s0,64(sp)
    80003e9e:	74e2                	ld	s1,56(sp)
    80003ea0:	7942                	ld	s2,48(sp)
    80003ea2:	79a2                	ld	s3,40(sp)
    80003ea4:	6ae2                	ld	s5,24(sp)
    80003ea6:	6b42                	ld	s6,16(sp)
    80003ea8:	6161                	addi	sp,sp,80
    80003eaa:	8082                	ret
    iunlockput(ip);
    80003eac:	8556                	mv	a0,s5
    80003eae:	ae1fe0ef          	jal	8000298e <iunlockput>
    return 0;
    80003eb2:	4a81                	li	s5,0
    80003eb4:	b7d5                	j	80003e98 <create+0x5c>
    80003eb6:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003eb8:	85da                	mv	a1,s6
    80003eba:	4088                	lw	a0,0(s1)
    80003ebc:	ec2fe0ef          	jal	8000257e <ialloc>
    80003ec0:	8a2a                	mv	s4,a0
    80003ec2:	cd15                	beqz	a0,80003efe <create+0xc2>
  ilock(ip);
    80003ec4:	82bfe0ef          	jal	800026ee <ilock>
  ip->major = major;
    80003ec8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003ecc:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003ed0:	4905                	li	s2,1
    80003ed2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003ed6:	8552                	mv	a0,s4
    80003ed8:	f62fe0ef          	jal	8000263a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003edc:	032b0763          	beq	s6,s2,80003f0a <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003ee0:	004a2603          	lw	a2,4(s4)
    80003ee4:	fb040593          	addi	a1,s0,-80
    80003ee8:	8526                	mv	a0,s1
    80003eea:	eddfe0ef          	jal	80002dc6 <dirlink>
    80003eee:	06054563          	bltz	a0,80003f58 <create+0x11c>
  iunlockput(dp);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	a9bfe0ef          	jal	8000298e <iunlockput>
  return ip;
    80003ef8:	8ad2                	mv	s5,s4
    80003efa:	7a02                	ld	s4,32(sp)
    80003efc:	bf71                	j	80003e98 <create+0x5c>
    iunlockput(dp);
    80003efe:	8526                	mv	a0,s1
    80003f00:	a8ffe0ef          	jal	8000298e <iunlockput>
    return 0;
    80003f04:	8ad2                	mv	s5,s4
    80003f06:	7a02                	ld	s4,32(sp)
    80003f08:	bf41                	j	80003e98 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f0a:	004a2603          	lw	a2,4(s4)
    80003f0e:	00003597          	auipc	a1,0x3
    80003f12:	6b258593          	addi	a1,a1,1714 # 800075c0 <etext+0x5c0>
    80003f16:	8552                	mv	a0,s4
    80003f18:	eaffe0ef          	jal	80002dc6 <dirlink>
    80003f1c:	02054e63          	bltz	a0,80003f58 <create+0x11c>
    80003f20:	40d0                	lw	a2,4(s1)
    80003f22:	00003597          	auipc	a1,0x3
    80003f26:	6a658593          	addi	a1,a1,1702 # 800075c8 <etext+0x5c8>
    80003f2a:	8552                	mv	a0,s4
    80003f2c:	e9bfe0ef          	jal	80002dc6 <dirlink>
    80003f30:	02054463          	bltz	a0,80003f58 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f34:	004a2603          	lw	a2,4(s4)
    80003f38:	fb040593          	addi	a1,s0,-80
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	e89fe0ef          	jal	80002dc6 <dirlink>
    80003f42:	00054b63          	bltz	a0,80003f58 <create+0x11c>
    dp->nlink++;  // for ".."
    80003f46:	04a4d783          	lhu	a5,74(s1)
    80003f4a:	2785                	addiw	a5,a5,1
    80003f4c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f50:	8526                	mv	a0,s1
    80003f52:	ee8fe0ef          	jal	8000263a <iupdate>
    80003f56:	bf71                	j	80003ef2 <create+0xb6>
  ip->nlink = 0;
    80003f58:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f5c:	8552                	mv	a0,s4
    80003f5e:	edcfe0ef          	jal	8000263a <iupdate>
  iunlockput(ip);
    80003f62:	8552                	mv	a0,s4
    80003f64:	a2bfe0ef          	jal	8000298e <iunlockput>
  iunlockput(dp);
    80003f68:	8526                	mv	a0,s1
    80003f6a:	a25fe0ef          	jal	8000298e <iunlockput>
  return 0;
    80003f6e:	7a02                	ld	s4,32(sp)
    80003f70:	b725                	j	80003e98 <create+0x5c>
    return 0;
    80003f72:	8aaa                	mv	s5,a0
    80003f74:	b715                	j	80003e98 <create+0x5c>

0000000080003f76 <sys_dup>:
{
    80003f76:	7179                	addi	sp,sp,-48
    80003f78:	f406                	sd	ra,40(sp)
    80003f7a:	f022                	sd	s0,32(sp)
    80003f7c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f7e:	fd840613          	addi	a2,s0,-40
    80003f82:	4581                	li	a1,0
    80003f84:	4501                	li	a0,0
    80003f86:	e21ff0ef          	jal	80003da6 <argfd>
    return -1;
    80003f8a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003f8c:	02054363          	bltz	a0,80003fb2 <sys_dup+0x3c>
    80003f90:	ec26                	sd	s1,24(sp)
    80003f92:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003f94:	fd843903          	ld	s2,-40(s0)
    80003f98:	854a                	mv	a0,s2
    80003f9a:	e65ff0ef          	jal	80003dfe <fdalloc>
    80003f9e:	84aa                	mv	s1,a0
    return -1;
    80003fa0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003fa2:	00054d63          	bltz	a0,80003fbc <sys_dup+0x46>
  filedup(f);
    80003fa6:	854a                	mv	a0,s2
    80003fa8:	c48ff0ef          	jal	800033f0 <filedup>
  return fd;
    80003fac:	87a6                	mv	a5,s1
    80003fae:	64e2                	ld	s1,24(sp)
    80003fb0:	6942                	ld	s2,16(sp)
}
    80003fb2:	853e                	mv	a0,a5
    80003fb4:	70a2                	ld	ra,40(sp)
    80003fb6:	7402                	ld	s0,32(sp)
    80003fb8:	6145                	addi	sp,sp,48
    80003fba:	8082                	ret
    80003fbc:	64e2                	ld	s1,24(sp)
    80003fbe:	6942                	ld	s2,16(sp)
    80003fc0:	bfcd                	j	80003fb2 <sys_dup+0x3c>

0000000080003fc2 <sys_read>:
{
    80003fc2:	7179                	addi	sp,sp,-48
    80003fc4:	f406                	sd	ra,40(sp)
    80003fc6:	f022                	sd	s0,32(sp)
    80003fc8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fca:	fd840593          	addi	a1,s0,-40
    80003fce:	4505                	li	a0,1
    80003fd0:	c61fd0ef          	jal	80001c30 <argaddr>
  argint(2, &n);
    80003fd4:	fe440593          	addi	a1,s0,-28
    80003fd8:	4509                	li	a0,2
    80003fda:	c3bfd0ef          	jal	80001c14 <argint>
  if(argfd(0, 0, &f) < 0)
    80003fde:	fe840613          	addi	a2,s0,-24
    80003fe2:	4581                	li	a1,0
    80003fe4:	4501                	li	a0,0
    80003fe6:	dc1ff0ef          	jal	80003da6 <argfd>
    80003fea:	87aa                	mv	a5,a0
    return -1;
    80003fec:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fee:	0007ca63          	bltz	a5,80004002 <sys_read+0x40>
  return fileread(f, p, n);
    80003ff2:	fe442603          	lw	a2,-28(s0)
    80003ff6:	fd843583          	ld	a1,-40(s0)
    80003ffa:	fe843503          	ld	a0,-24(s0)
    80003ffe:	d58ff0ef          	jal	80003556 <fileread>
}
    80004002:	70a2                	ld	ra,40(sp)
    80004004:	7402                	ld	s0,32(sp)
    80004006:	6145                	addi	sp,sp,48
    80004008:	8082                	ret

000000008000400a <sys_write>:
{
    8000400a:	7179                	addi	sp,sp,-48
    8000400c:	f406                	sd	ra,40(sp)
    8000400e:	f022                	sd	s0,32(sp)
    80004010:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004012:	fd840593          	addi	a1,s0,-40
    80004016:	4505                	li	a0,1
    80004018:	c19fd0ef          	jal	80001c30 <argaddr>
  argint(2, &n);
    8000401c:	fe440593          	addi	a1,s0,-28
    80004020:	4509                	li	a0,2
    80004022:	bf3fd0ef          	jal	80001c14 <argint>
  if(argfd(0, 0, &f) < 0)
    80004026:	fe840613          	addi	a2,s0,-24
    8000402a:	4581                	li	a1,0
    8000402c:	4501                	li	a0,0
    8000402e:	d79ff0ef          	jal	80003da6 <argfd>
    80004032:	87aa                	mv	a5,a0
    return -1;
    80004034:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004036:	0007ca63          	bltz	a5,8000404a <sys_write+0x40>
  return filewrite(f, p, n);
    8000403a:	fe442603          	lw	a2,-28(s0)
    8000403e:	fd843583          	ld	a1,-40(s0)
    80004042:	fe843503          	ld	a0,-24(s0)
    80004046:	dceff0ef          	jal	80003614 <filewrite>
}
    8000404a:	70a2                	ld	ra,40(sp)
    8000404c:	7402                	ld	s0,32(sp)
    8000404e:	6145                	addi	sp,sp,48
    80004050:	8082                	ret

0000000080004052 <sys_close>:
{
    80004052:	1101                	addi	sp,sp,-32
    80004054:	ec06                	sd	ra,24(sp)
    80004056:	e822                	sd	s0,16(sp)
    80004058:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000405a:	fe040613          	addi	a2,s0,-32
    8000405e:	fec40593          	addi	a1,s0,-20
    80004062:	4501                	li	a0,0
    80004064:	d43ff0ef          	jal	80003da6 <argfd>
    return -1;
    80004068:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000406a:	02054063          	bltz	a0,8000408a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000406e:	cf9fc0ef          	jal	80000d66 <myproc>
    80004072:	fec42783          	lw	a5,-20(s0)
    80004076:	07e9                	addi	a5,a5,26
    80004078:	078e                	slli	a5,a5,0x3
    8000407a:	953e                	add	a0,a0,a5
    8000407c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004080:	fe043503          	ld	a0,-32(s0)
    80004084:	bb2ff0ef          	jal	80003436 <fileclose>
  return 0;
    80004088:	4781                	li	a5,0
}
    8000408a:	853e                	mv	a0,a5
    8000408c:	60e2                	ld	ra,24(sp)
    8000408e:	6442                	ld	s0,16(sp)
    80004090:	6105                	addi	sp,sp,32
    80004092:	8082                	ret

0000000080004094 <sys_fstat>:
{
    80004094:	1101                	addi	sp,sp,-32
    80004096:	ec06                	sd	ra,24(sp)
    80004098:	e822                	sd	s0,16(sp)
    8000409a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000409c:	fe040593          	addi	a1,s0,-32
    800040a0:	4505                	li	a0,1
    800040a2:	b8ffd0ef          	jal	80001c30 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800040a6:	fe840613          	addi	a2,s0,-24
    800040aa:	4581                	li	a1,0
    800040ac:	4501                	li	a0,0
    800040ae:	cf9ff0ef          	jal	80003da6 <argfd>
    800040b2:	87aa                	mv	a5,a0
    return -1;
    800040b4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040b6:	0007c863          	bltz	a5,800040c6 <sys_fstat+0x32>
  return filestat(f, st);
    800040ba:	fe043583          	ld	a1,-32(s0)
    800040be:	fe843503          	ld	a0,-24(s0)
    800040c2:	c36ff0ef          	jal	800034f8 <filestat>
}
    800040c6:	60e2                	ld	ra,24(sp)
    800040c8:	6442                	ld	s0,16(sp)
    800040ca:	6105                	addi	sp,sp,32
    800040cc:	8082                	ret

00000000800040ce <sys_link>:
{
    800040ce:	7169                	addi	sp,sp,-304
    800040d0:	f606                	sd	ra,296(sp)
    800040d2:	f222                	sd	s0,288(sp)
    800040d4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040d6:	08000613          	li	a2,128
    800040da:	ed040593          	addi	a1,s0,-304
    800040de:	4501                	li	a0,0
    800040e0:	b6dfd0ef          	jal	80001c4c <argstr>
    return -1;
    800040e4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040e6:	0c054e63          	bltz	a0,800041c2 <sys_link+0xf4>
    800040ea:	08000613          	li	a2,128
    800040ee:	f5040593          	addi	a1,s0,-176
    800040f2:	4505                	li	a0,1
    800040f4:	b59fd0ef          	jal	80001c4c <argstr>
    return -1;
    800040f8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040fa:	0c054463          	bltz	a0,800041c2 <sys_link+0xf4>
    800040fe:	ee26                	sd	s1,280(sp)
  begin_op();
    80004100:	f1dfe0ef          	jal	8000301c <begin_op>
  if((ip = namei(old)) == 0){
    80004104:	ed040513          	addi	a0,s0,-304
    80004108:	d59fe0ef          	jal	80002e60 <namei>
    8000410c:	84aa                	mv	s1,a0
    8000410e:	c53d                	beqz	a0,8000417c <sys_link+0xae>
  ilock(ip);
    80004110:	ddefe0ef          	jal	800026ee <ilock>
  if(ip->type == T_DIR){
    80004114:	04449703          	lh	a4,68(s1)
    80004118:	4785                	li	a5,1
    8000411a:	06f70663          	beq	a4,a5,80004186 <sys_link+0xb8>
    8000411e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004120:	04a4d783          	lhu	a5,74(s1)
    80004124:	2785                	addiw	a5,a5,1
    80004126:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000412a:	8526                	mv	a0,s1
    8000412c:	d0efe0ef          	jal	8000263a <iupdate>
  iunlock(ip);
    80004130:	8526                	mv	a0,s1
    80004132:	e6afe0ef          	jal	8000279c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004136:	fd040593          	addi	a1,s0,-48
    8000413a:	f5040513          	addi	a0,s0,-176
    8000413e:	d3dfe0ef          	jal	80002e7a <nameiparent>
    80004142:	892a                	mv	s2,a0
    80004144:	cd21                	beqz	a0,8000419c <sys_link+0xce>
  ilock(dp);
    80004146:	da8fe0ef          	jal	800026ee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000414a:	00092703          	lw	a4,0(s2)
    8000414e:	409c                	lw	a5,0(s1)
    80004150:	04f71363          	bne	a4,a5,80004196 <sys_link+0xc8>
    80004154:	40d0                	lw	a2,4(s1)
    80004156:	fd040593          	addi	a1,s0,-48
    8000415a:	854a                	mv	a0,s2
    8000415c:	c6bfe0ef          	jal	80002dc6 <dirlink>
    80004160:	02054b63          	bltz	a0,80004196 <sys_link+0xc8>
  iunlockput(dp);
    80004164:	854a                	mv	a0,s2
    80004166:	829fe0ef          	jal	8000298e <iunlockput>
  iput(ip);
    8000416a:	8526                	mv	a0,s1
    8000416c:	f9afe0ef          	jal	80002906 <iput>
  end_op();
    80004170:	f17fe0ef          	jal	80003086 <end_op>
  return 0;
    80004174:	4781                	li	a5,0
    80004176:	64f2                	ld	s1,280(sp)
    80004178:	6952                	ld	s2,272(sp)
    8000417a:	a0a1                	j	800041c2 <sys_link+0xf4>
    end_op();
    8000417c:	f0bfe0ef          	jal	80003086 <end_op>
    return -1;
    80004180:	57fd                	li	a5,-1
    80004182:	64f2                	ld	s1,280(sp)
    80004184:	a83d                	j	800041c2 <sys_link+0xf4>
    iunlockput(ip);
    80004186:	8526                	mv	a0,s1
    80004188:	807fe0ef          	jal	8000298e <iunlockput>
    end_op();
    8000418c:	efbfe0ef          	jal	80003086 <end_op>
    return -1;
    80004190:	57fd                	li	a5,-1
    80004192:	64f2                	ld	s1,280(sp)
    80004194:	a03d                	j	800041c2 <sys_link+0xf4>
    iunlockput(dp);
    80004196:	854a                	mv	a0,s2
    80004198:	ff6fe0ef          	jal	8000298e <iunlockput>
  ilock(ip);
    8000419c:	8526                	mv	a0,s1
    8000419e:	d50fe0ef          	jal	800026ee <ilock>
  ip->nlink--;
    800041a2:	04a4d783          	lhu	a5,74(s1)
    800041a6:	37fd                	addiw	a5,a5,-1
    800041a8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041ac:	8526                	mv	a0,s1
    800041ae:	c8cfe0ef          	jal	8000263a <iupdate>
  iunlockput(ip);
    800041b2:	8526                	mv	a0,s1
    800041b4:	fdafe0ef          	jal	8000298e <iunlockput>
  end_op();
    800041b8:	ecffe0ef          	jal	80003086 <end_op>
  return -1;
    800041bc:	57fd                	li	a5,-1
    800041be:	64f2                	ld	s1,280(sp)
    800041c0:	6952                	ld	s2,272(sp)
}
    800041c2:	853e                	mv	a0,a5
    800041c4:	70b2                	ld	ra,296(sp)
    800041c6:	7412                	ld	s0,288(sp)
    800041c8:	6155                	addi	sp,sp,304
    800041ca:	8082                	ret

00000000800041cc <sys_unlink>:
{
    800041cc:	7151                	addi	sp,sp,-240
    800041ce:	f586                	sd	ra,232(sp)
    800041d0:	f1a2                	sd	s0,224(sp)
    800041d2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800041d4:	08000613          	li	a2,128
    800041d8:	f3040593          	addi	a1,s0,-208
    800041dc:	4501                	li	a0,0
    800041de:	a6ffd0ef          	jal	80001c4c <argstr>
    800041e2:	16054063          	bltz	a0,80004342 <sys_unlink+0x176>
    800041e6:	eda6                	sd	s1,216(sp)
  begin_op();
    800041e8:	e35fe0ef          	jal	8000301c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800041ec:	fb040593          	addi	a1,s0,-80
    800041f0:	f3040513          	addi	a0,s0,-208
    800041f4:	c87fe0ef          	jal	80002e7a <nameiparent>
    800041f8:	84aa                	mv	s1,a0
    800041fa:	c945                	beqz	a0,800042aa <sys_unlink+0xde>
  ilock(dp);
    800041fc:	cf2fe0ef          	jal	800026ee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004200:	00003597          	auipc	a1,0x3
    80004204:	3c058593          	addi	a1,a1,960 # 800075c0 <etext+0x5c0>
    80004208:	fb040513          	addi	a0,s0,-80
    8000420c:	9d9fe0ef          	jal	80002be4 <namecmp>
    80004210:	10050e63          	beqz	a0,8000432c <sys_unlink+0x160>
    80004214:	00003597          	auipc	a1,0x3
    80004218:	3b458593          	addi	a1,a1,948 # 800075c8 <etext+0x5c8>
    8000421c:	fb040513          	addi	a0,s0,-80
    80004220:	9c5fe0ef          	jal	80002be4 <namecmp>
    80004224:	10050463          	beqz	a0,8000432c <sys_unlink+0x160>
    80004228:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000422a:	f2c40613          	addi	a2,s0,-212
    8000422e:	fb040593          	addi	a1,s0,-80
    80004232:	8526                	mv	a0,s1
    80004234:	9c7fe0ef          	jal	80002bfa <dirlookup>
    80004238:	892a                	mv	s2,a0
    8000423a:	0e050863          	beqz	a0,8000432a <sys_unlink+0x15e>
  ilock(ip);
    8000423e:	cb0fe0ef          	jal	800026ee <ilock>
  if(ip->nlink < 1)
    80004242:	04a91783          	lh	a5,74(s2)
    80004246:	06f05763          	blez	a5,800042b4 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000424a:	04491703          	lh	a4,68(s2)
    8000424e:	4785                	li	a5,1
    80004250:	06f70963          	beq	a4,a5,800042c2 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004254:	4641                	li	a2,16
    80004256:	4581                	li	a1,0
    80004258:	fc040513          	addi	a0,s0,-64
    8000425c:	ef3fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004260:	4741                	li	a4,16
    80004262:	f2c42683          	lw	a3,-212(s0)
    80004266:	fc040613          	addi	a2,s0,-64
    8000426a:	4581                	li	a1,0
    8000426c:	8526                	mv	a0,s1
    8000426e:	867fe0ef          	jal	80002ad4 <writei>
    80004272:	47c1                	li	a5,16
    80004274:	08f51b63          	bne	a0,a5,8000430a <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004278:	04491703          	lh	a4,68(s2)
    8000427c:	4785                	li	a5,1
    8000427e:	08f70d63          	beq	a4,a5,80004318 <sys_unlink+0x14c>
  iunlockput(dp);
    80004282:	8526                	mv	a0,s1
    80004284:	f0afe0ef          	jal	8000298e <iunlockput>
  ip->nlink--;
    80004288:	04a95783          	lhu	a5,74(s2)
    8000428c:	37fd                	addiw	a5,a5,-1
    8000428e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004292:	854a                	mv	a0,s2
    80004294:	ba6fe0ef          	jal	8000263a <iupdate>
  iunlockput(ip);
    80004298:	854a                	mv	a0,s2
    8000429a:	ef4fe0ef          	jal	8000298e <iunlockput>
  end_op();
    8000429e:	de9fe0ef          	jal	80003086 <end_op>
  return 0;
    800042a2:	4501                	li	a0,0
    800042a4:	64ee                	ld	s1,216(sp)
    800042a6:	694e                	ld	s2,208(sp)
    800042a8:	a849                	j	8000433a <sys_unlink+0x16e>
    end_op();
    800042aa:	dddfe0ef          	jal	80003086 <end_op>
    return -1;
    800042ae:	557d                	li	a0,-1
    800042b0:	64ee                	ld	s1,216(sp)
    800042b2:	a061                	j	8000433a <sys_unlink+0x16e>
    800042b4:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800042b6:	00003517          	auipc	a0,0x3
    800042ba:	31a50513          	addi	a0,a0,794 # 800075d0 <etext+0x5d0>
    800042be:	3d4010ef          	jal	80005692 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042c2:	04c92703          	lw	a4,76(s2)
    800042c6:	02000793          	li	a5,32
    800042ca:	f8e7f5e3          	bgeu	a5,a4,80004254 <sys_unlink+0x88>
    800042ce:	e5ce                	sd	s3,200(sp)
    800042d0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042d4:	4741                	li	a4,16
    800042d6:	86ce                	mv	a3,s3
    800042d8:	f1840613          	addi	a2,s0,-232
    800042dc:	4581                	li	a1,0
    800042de:	854a                	mv	a0,s2
    800042e0:	ef8fe0ef          	jal	800029d8 <readi>
    800042e4:	47c1                	li	a5,16
    800042e6:	00f51c63          	bne	a0,a5,800042fe <sys_unlink+0x132>
    if(de.inum != 0)
    800042ea:	f1845783          	lhu	a5,-232(s0)
    800042ee:	efa1                	bnez	a5,80004346 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042f0:	29c1                	addiw	s3,s3,16
    800042f2:	04c92783          	lw	a5,76(s2)
    800042f6:	fcf9efe3          	bltu	s3,a5,800042d4 <sys_unlink+0x108>
    800042fa:	69ae                	ld	s3,200(sp)
    800042fc:	bfa1                	j	80004254 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800042fe:	00003517          	auipc	a0,0x3
    80004302:	2ea50513          	addi	a0,a0,746 # 800075e8 <etext+0x5e8>
    80004306:	38c010ef          	jal	80005692 <panic>
    8000430a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    8000430c:	00003517          	auipc	a0,0x3
    80004310:	2f450513          	addi	a0,a0,756 # 80007600 <etext+0x600>
    80004314:	37e010ef          	jal	80005692 <panic>
    dp->nlink--;
    80004318:	04a4d783          	lhu	a5,74(s1)
    8000431c:	37fd                	addiw	a5,a5,-1
    8000431e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004322:	8526                	mv	a0,s1
    80004324:	b16fe0ef          	jal	8000263a <iupdate>
    80004328:	bfa9                	j	80004282 <sys_unlink+0xb6>
    8000432a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000432c:	8526                	mv	a0,s1
    8000432e:	e60fe0ef          	jal	8000298e <iunlockput>
  end_op();
    80004332:	d55fe0ef          	jal	80003086 <end_op>
  return -1;
    80004336:	557d                	li	a0,-1
    80004338:	64ee                	ld	s1,216(sp)
}
    8000433a:	70ae                	ld	ra,232(sp)
    8000433c:	740e                	ld	s0,224(sp)
    8000433e:	616d                	addi	sp,sp,240
    80004340:	8082                	ret
    return -1;
    80004342:	557d                	li	a0,-1
    80004344:	bfdd                	j	8000433a <sys_unlink+0x16e>
    iunlockput(ip);
    80004346:	854a                	mv	a0,s2
    80004348:	e46fe0ef          	jal	8000298e <iunlockput>
    goto bad;
    8000434c:	694e                	ld	s2,208(sp)
    8000434e:	69ae                	ld	s3,200(sp)
    80004350:	bff1                	j	8000432c <sys_unlink+0x160>

0000000080004352 <sys_open>:

uint64
sys_open(void)
{
    80004352:	7129                	addi	sp,sp,-320
    80004354:	fe06                	sd	ra,312(sp)
    80004356:	fa22                	sd	s0,304(sp)
    80004358:	0280                	addi	s0,sp,320
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000435a:	f4c40593          	addi	a1,s0,-180
    8000435e:	4505                	li	a0,1
    80004360:	8b5fd0ef          	jal	80001c14 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004364:	08000613          	li	a2,128
    80004368:	f5040593          	addi	a1,s0,-176
    8000436c:	4501                	li	a0,0
    8000436e:	8dffd0ef          	jal	80001c4c <argstr>
    80004372:	87aa                	mv	a5,a0
    return -1;
    80004374:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004376:	1e07c363          	bltz	a5,8000455c <sys_open+0x20a>
    8000437a:	f626                	sd	s1,296(sp)
    8000437c:	f24a                	sd	s2,288(sp)
    8000437e:	ee4e                	sd	s3,280(sp)

  begin_op();
    80004380:	c9dfe0ef          	jal	8000301c <begin_op>

  // Same as before
  if(omode & O_CREATE)
    80004384:	f4c42783          	lw	a5,-180(s0)
    80004388:	2007f793          	andi	a5,a5,512
    8000438c:	c7b1                	beqz	a5,800043d8 <sys_open+0x86>
  {
    ip = create(path, T_FILE, 0, 0);  // create a file at the specified path else return error.
    8000438e:	4681                	li	a3,0
    80004390:	4601                	li	a2,0
    80004392:	4589                	li	a1,2
    80004394:	f5040513          	addi	a0,s0,-176
    80004398:	aa5ff0ef          	jal	80003e3c <create>
    8000439c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000439e:	c515                	beqz	a0,800043ca <sys_open+0x78>

  int symlink_depth = 0; // Recursive counter
  int len ;

  char next[MAXPATH+1];
  if(!(omode & O_NOFOLLOW)) // O_NOFOLLOW is set, so we open the symlink and not follow. (Step 2)
    800043a0:	f4c42783          	lw	a5,-180(s0)
    800043a4:	03479713          	slli	a4,a5,0x34
    800043a8:	08075363          	bgez	a4,8000442e <sys_open+0xdc>
    end_op();
    return -1;
  }

  // Same as before
  if(ip->type == T_DIR && omode != O_RDONLY)
    800043ac:	04451703          	lh	a4,68(a0)
    800043b0:	4785                	li	a5,1
    800043b2:	14f71263          	bne	a4,a5,800044f6 <sys_open+0x1a4>
  {
    iunlockput(ip);
    800043b6:	8526                	mv	a0,s1
    800043b8:	dd6fe0ef          	jal	8000298e <iunlockput>
    end_op();
    800043bc:	ccbfe0ef          	jal	80003086 <end_op>
    return -1;
    800043c0:	557d                	li	a0,-1
    800043c2:	74b2                	ld	s1,296(sp)
    800043c4:	7912                	ld	s2,288(sp)
    800043c6:	69f2                	ld	s3,280(sp)
    800043c8:	aa51                	j	8000455c <sys_open+0x20a>
      end_op();
    800043ca:	cbdfe0ef          	jal	80003086 <end_op>
      return -1;
    800043ce:	557d                	li	a0,-1
    800043d0:	74b2                	ld	s1,296(sp)
    800043d2:	7912                	ld	s2,288(sp)
    800043d4:	69f2                	ld	s3,280(sp)
    800043d6:	a259                	j	8000455c <sys_open+0x20a>
    if((ip = namei(path)) == 0)
    800043d8:	f5040513          	addi	a0,s0,-176
    800043dc:	a85fe0ef          	jal	80002e60 <namei>
    800043e0:	84aa                	mv	s1,a0
    800043e2:	c105                	beqz	a0,80004402 <sys_open+0xb0>
    ilock(ip);
    800043e4:	b0afe0ef          	jal	800026ee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800043e8:	04449703          	lh	a4,68(s1)
    800043ec:	4785                	li	a5,1
    800043ee:	02f70163          	beq	a4,a5,80004410 <sys_open+0xbe>
  if(!(omode & O_NOFOLLOW)) // O_NOFOLLOW is set, so we open the symlink and not follow. (Step 2)
    800043f2:	f4c42783          	lw	a5,-180(s0)
    800043f6:	03479713          	slli	a4,a5,0x34
    800043fa:	0e074e63          	bltz	a4,800044f6 <sys_open+0x1a4>
    800043fe:	ea52                	sd	s4,272(sp)
    80004400:	a805                	j	80004430 <sys_open+0xde>
      end_op();
    80004402:	c85fe0ef          	jal	80003086 <end_op>
      return -1;
    80004406:	557d                	li	a0,-1
    80004408:	74b2                	ld	s1,296(sp)
    8000440a:	7912                	ld	s2,288(sp)
    8000440c:	69f2                	ld	s3,280(sp)
    8000440e:	a2b9                	j	8000455c <sys_open+0x20a>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004410:	f4c42783          	lw	a5,-180(s0)
    80004414:	e399                	bnez	a5,8000441a <sys_open+0xc8>
    80004416:	ea52                	sd	s4,272(sp)
    80004418:	a821                	j	80004430 <sys_open+0xde>
      iunlockput(ip);
    8000441a:	8526                	mv	a0,s1
    8000441c:	d72fe0ef          	jal	8000298e <iunlockput>
      end_op();
    80004420:	c67fe0ef          	jal	80003086 <end_op>
      return -1;
    80004424:	557d                	li	a0,-1
    80004426:	74b2                	ld	s1,296(sp)
    80004428:	7912                	ld	s2,288(sp)
    8000442a:	69f2                	ld	s3,280(sp)
    8000442c:	aa05                	j	8000455c <sys_open+0x20a>
    8000442e:	ea52                	sd	s4,272(sp)
  int symlink_depth = 0; // Recursive counter
    80004430:	4981                	li	s3,0
    while (symlink_depth < 10 && ip->type == T_SYMLINK) // (Step 4)
    80004432:	4911                	li	s2,4
    80004434:	4a29                	li	s4,10
    80004436:	04449783          	lh	a5,68(s1)
    8000443a:	0b279563          	bne	a5,s2,800044e4 <sys_open+0x192>
      readi(ip,0,(uint64)&len,0,sizeof(len));   // (Step 1)
    8000443e:	874a                	mv	a4,s2
    80004440:	4681                	li	a3,0
    80004442:	f4840613          	addi	a2,s0,-184
    80004446:	4581                	li	a1,0
    80004448:	8526                	mv	a0,s1
    8000444a:	d8efe0ef          	jal	800029d8 <readi>
      readi(ip,0,(uint64)next,sizeof(len),len); // (Step 2)
    8000444e:	f4842703          	lw	a4,-184(s0)
    80004452:	86ca                	mv	a3,s2
    80004454:	ec040613          	addi	a2,s0,-320
    80004458:	4581                	li	a1,0
    8000445a:	8526                	mv	a0,s1
    8000445c:	d7cfe0ef          	jal	800029d8 <readi>
      next[len]= 0;                             // (Step 3)
    80004460:	f4842783          	lw	a5,-184(s0)
    80004464:	fd078793          	addi	a5,a5,-48
    80004468:	97a2                	add	a5,a5,s0
    8000446a:	ee078823          	sb	zero,-272(a5)
      iunlockput(ip);                           // (Step 4)
    8000446e:	8526                	mv	a0,s1
    80004470:	d1efe0ef          	jal	8000298e <iunlockput>
      if((ip=namei(next))==0)                   // (Step 5)
    80004474:	ec040513          	addi	a0,s0,-320
    80004478:	9e9fe0ef          	jal	80002e60 <namei>
    8000447c:	84aa                	mv	s1,a0
    8000447e:	c10d                	beqz	a0,800044a0 <sys_open+0x14e>
      ilock(ip);
    80004480:	a6efe0ef          	jal	800026ee <ilock>
      symlink_depth++;
    80004484:	2985                	addiw	s3,s3,1
    while (symlink_depth < 10 && ip->type == T_SYMLINK) // (Step 4)
    80004486:	fb4998e3          	bne	s3,s4,80004436 <sys_open+0xe4>
    iunlockput(ip);
    8000448a:	8526                	mv	a0,s1
    8000448c:	d02fe0ef          	jal	8000298e <iunlockput>
    end_op();
    80004490:	bf7fe0ef          	jal	80003086 <end_op>
    return -1;
    80004494:	557d                	li	a0,-1
    80004496:	74b2                	ld	s1,296(sp)
    80004498:	7912                	ld	s2,288(sp)
    8000449a:	69f2                	ld	s3,280(sp)
    8000449c:	6a52                	ld	s4,272(sp)
    8000449e:	a87d                	j	8000455c <sys_open+0x20a>
        end_op();
    800044a0:	be7fe0ef          	jal	80003086 <end_op>
        return -1;
    800044a4:	557d                	li	a0,-1
    800044a6:	74b2                	ld	s1,296(sp)
    800044a8:	7912                	ld	s2,288(sp)
    800044aa:	69f2                	ld	s3,280(sp)
    800044ac:	6a52                	ld	s4,272(sp)
    800044ae:	a07d                	j	8000455c <sys_open+0x20a>
    800044b0:	6a52                	ld	s4,272(sp)
    800044b2:	b711                	j	800043b6 <sys_open+0x64>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    800044b4:	854e                	mv	a0,s3
    800044b6:	f81fe0ef          	jal	80003436 <fileclose>
    iunlockput(ip);
    800044ba:	8526                	mv	a0,s1
    800044bc:	cd2fe0ef          	jal	8000298e <iunlockput>
    end_op();
    800044c0:	bc7fe0ef          	jal	80003086 <end_op>
    return -1;
    800044c4:	557d                	li	a0,-1
    800044c6:	74b2                	ld	s1,296(sp)
    800044c8:	7912                	ld	s2,288(sp)
    800044ca:	69f2                	ld	s3,280(sp)
    800044cc:	a841                	j	8000455c <sys_open+0x20a>
  }

  if(ip->type == T_DEVICE){
    f->type = FD_DEVICE;
    800044ce:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800044d2:	04649783          	lh	a5,70(s1)
    800044d6:	02f99223          	sh	a5,36(s3)
    800044da:	a089                	j	8000451c <sys_open+0x1ca>
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  if((omode & O_TRUNC) && ip->type == T_FILE){
    itrunc(ip);
    800044dc:	8526                	mv	a0,s1
    800044de:	afefe0ef          	jal	800027dc <itrunc>
    800044e2:	a0a5                	j	8000454a <sys_open+0x1f8>
  if(ip->type == T_DIR && omode != O_RDONLY)
    800044e4:	04449703          	lh	a4,68(s1)
    800044e8:	4785                	li	a5,1
    800044ea:	06f71d63          	bne	a4,a5,80004564 <sys_open+0x212>
    800044ee:	f4c42783          	lw	a5,-180(s0)
    800044f2:	ffdd                	bnez	a5,800044b0 <sys_open+0x15e>
    800044f4:	6a52                	ld	s4,272(sp)
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800044f6:	e9dfe0ef          	jal	80003392 <filealloc>
    800044fa:	89aa                	mv	s3,a0
    800044fc:	dd5d                	beqz	a0,800044ba <sys_open+0x168>
    800044fe:	901ff0ef          	jal	80003dfe <fdalloc>
    80004502:	892a                	mv	s2,a0
    80004504:	fa0548e3          	bltz	a0,800044b4 <sys_open+0x162>
  if(ip->type == T_DEVICE){
    80004508:	04449703          	lh	a4,68(s1)
    8000450c:	478d                	li	a5,3
    8000450e:	fcf700e3          	beq	a4,a5,800044ce <sys_open+0x17c>
    f->type = FD_INODE;
    80004512:	4789                	li	a5,2
    80004514:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004518:	0209a023          	sw	zero,32(s3)
  f->ip = ip;
    8000451c:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004520:	f4c42783          	lw	a5,-180(s0)
    80004524:	0017c713          	xori	a4,a5,1
    80004528:	8b05                	andi	a4,a4,1
    8000452a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000452e:	0037f713          	andi	a4,a5,3
    80004532:	00e03733          	snez	a4,a4
    80004536:	00e984a3          	sb	a4,9(s3)
  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000453a:	4007f793          	andi	a5,a5,1024
    8000453e:	c791                	beqz	a5,8000454a <sys_open+0x1f8>
    80004540:	04449703          	lh	a4,68(s1)
    80004544:	4789                	li	a5,2
    80004546:	f8f70be3          	beq	a4,a5,800044dc <sys_open+0x18a>
  }

  iunlock(ip);
    8000454a:	8526                	mv	a0,s1
    8000454c:	a50fe0ef          	jal	8000279c <iunlock>
  end_op();
    80004550:	b37fe0ef          	jal	80003086 <end_op>

  return fd;
    80004554:	854a                	mv	a0,s2
    80004556:	74b2                	ld	s1,296(sp)
    80004558:	7912                	ld	s2,288(sp)
    8000455a:	69f2                	ld	s3,280(sp)
}
    8000455c:	70f2                	ld	ra,312(sp)
    8000455e:	7452                	ld	s0,304(sp)
    80004560:	6131                	addi	sp,sp,320
    80004562:	8082                	ret
    80004564:	6a52                	ld	s4,272(sp)
    80004566:	bf41                	j	800044f6 <sys_open+0x1a4>

0000000080004568 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004568:	7175                	addi	sp,sp,-144
    8000456a:	e506                	sd	ra,136(sp)
    8000456c:	e122                	sd	s0,128(sp)
    8000456e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004570:	aadfe0ef          	jal	8000301c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004574:	08000613          	li	a2,128
    80004578:	f7040593          	addi	a1,s0,-144
    8000457c:	4501                	li	a0,0
    8000457e:	ecefd0ef          	jal	80001c4c <argstr>
    80004582:	02054363          	bltz	a0,800045a8 <sys_mkdir+0x40>
    80004586:	4681                	li	a3,0
    80004588:	4601                	li	a2,0
    8000458a:	4585                	li	a1,1
    8000458c:	f7040513          	addi	a0,s0,-144
    80004590:	8adff0ef          	jal	80003e3c <create>
    80004594:	c911                	beqz	a0,800045a8 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004596:	bf8fe0ef          	jal	8000298e <iunlockput>
  end_op();
    8000459a:	aedfe0ef          	jal	80003086 <end_op>
  return 0;
    8000459e:	4501                	li	a0,0
}
    800045a0:	60aa                	ld	ra,136(sp)
    800045a2:	640a                	ld	s0,128(sp)
    800045a4:	6149                	addi	sp,sp,144
    800045a6:	8082                	ret
    end_op();
    800045a8:	adffe0ef          	jal	80003086 <end_op>
    return -1;
    800045ac:	557d                	li	a0,-1
    800045ae:	bfcd                	j	800045a0 <sys_mkdir+0x38>

00000000800045b0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800045b0:	7135                	addi	sp,sp,-160
    800045b2:	ed06                	sd	ra,152(sp)
    800045b4:	e922                	sd	s0,144(sp)
    800045b6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800045b8:	a65fe0ef          	jal	8000301c <begin_op>
  argint(1, &major);
    800045bc:	f6c40593          	addi	a1,s0,-148
    800045c0:	4505                	li	a0,1
    800045c2:	e52fd0ef          	jal	80001c14 <argint>
  argint(2, &minor);
    800045c6:	f6840593          	addi	a1,s0,-152
    800045ca:	4509                	li	a0,2
    800045cc:	e48fd0ef          	jal	80001c14 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045d0:	08000613          	li	a2,128
    800045d4:	f7040593          	addi	a1,s0,-144
    800045d8:	4501                	li	a0,0
    800045da:	e72fd0ef          	jal	80001c4c <argstr>
    800045de:	02054563          	bltz	a0,80004608 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800045e2:	f6841683          	lh	a3,-152(s0)
    800045e6:	f6c41603          	lh	a2,-148(s0)
    800045ea:	458d                	li	a1,3
    800045ec:	f7040513          	addi	a0,s0,-144
    800045f0:	84dff0ef          	jal	80003e3c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045f4:	c911                	beqz	a0,80004608 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045f6:	b98fe0ef          	jal	8000298e <iunlockput>
  end_op();
    800045fa:	a8dfe0ef          	jal	80003086 <end_op>
  return 0;
    800045fe:	4501                	li	a0,0
}
    80004600:	60ea                	ld	ra,152(sp)
    80004602:	644a                	ld	s0,144(sp)
    80004604:	610d                	addi	sp,sp,160
    80004606:	8082                	ret
    end_op();
    80004608:	a7ffe0ef          	jal	80003086 <end_op>
    return -1;
    8000460c:	557d                	li	a0,-1
    8000460e:	bfcd                	j	80004600 <sys_mknod+0x50>

0000000080004610 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004610:	7135                	addi	sp,sp,-160
    80004612:	ed06                	sd	ra,152(sp)
    80004614:	e922                	sd	s0,144(sp)
    80004616:	e14a                	sd	s2,128(sp)
    80004618:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000461a:	f4cfc0ef          	jal	80000d66 <myproc>
    8000461e:	892a                	mv	s2,a0
  
  begin_op();
    80004620:	9fdfe0ef          	jal	8000301c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004624:	08000613          	li	a2,128
    80004628:	f6040593          	addi	a1,s0,-160
    8000462c:	4501                	li	a0,0
    8000462e:	e1efd0ef          	jal	80001c4c <argstr>
    80004632:	04054363          	bltz	a0,80004678 <sys_chdir+0x68>
    80004636:	e526                	sd	s1,136(sp)
    80004638:	f6040513          	addi	a0,s0,-160
    8000463c:	825fe0ef          	jal	80002e60 <namei>
    80004640:	84aa                	mv	s1,a0
    80004642:	c915                	beqz	a0,80004676 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004644:	8aafe0ef          	jal	800026ee <ilock>
  if(ip->type != T_DIR){
    80004648:	04449703          	lh	a4,68(s1)
    8000464c:	4785                	li	a5,1
    8000464e:	02f71963          	bne	a4,a5,80004680 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004652:	8526                	mv	a0,s1
    80004654:	948fe0ef          	jal	8000279c <iunlock>
  iput(p->cwd);
    80004658:	15093503          	ld	a0,336(s2)
    8000465c:	aaafe0ef          	jal	80002906 <iput>
  end_op();
    80004660:	a27fe0ef          	jal	80003086 <end_op>
  p->cwd = ip;
    80004664:	14993823          	sd	s1,336(s2)
  return 0;
    80004668:	4501                	li	a0,0
    8000466a:	64aa                	ld	s1,136(sp)
}
    8000466c:	60ea                	ld	ra,152(sp)
    8000466e:	644a                	ld	s0,144(sp)
    80004670:	690a                	ld	s2,128(sp)
    80004672:	610d                	addi	sp,sp,160
    80004674:	8082                	ret
    80004676:	64aa                	ld	s1,136(sp)
    end_op();
    80004678:	a0ffe0ef          	jal	80003086 <end_op>
    return -1;
    8000467c:	557d                	li	a0,-1
    8000467e:	b7fd                	j	8000466c <sys_chdir+0x5c>
    iunlockput(ip);
    80004680:	8526                	mv	a0,s1
    80004682:	b0cfe0ef          	jal	8000298e <iunlockput>
    end_op();
    80004686:	a01fe0ef          	jal	80003086 <end_op>
    return -1;
    8000468a:	557d                	li	a0,-1
    8000468c:	64aa                	ld	s1,136(sp)
    8000468e:	bff9                	j	8000466c <sys_chdir+0x5c>

0000000080004690 <sys_exec>:

uint64
sys_exec(void)
{
    80004690:	7121                	addi	sp,sp,-448
    80004692:	ff06                	sd	ra,440(sp)
    80004694:	fb22                	sd	s0,432(sp)
    80004696:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004698:	e4840593          	addi	a1,s0,-440
    8000469c:	4505                	li	a0,1
    8000469e:	d92fd0ef          	jal	80001c30 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800046a2:	08000613          	li	a2,128
    800046a6:	f5040593          	addi	a1,s0,-176
    800046aa:	4501                	li	a0,0
    800046ac:	da0fd0ef          	jal	80001c4c <argstr>
    800046b0:	87aa                	mv	a5,a0
    return -1;
    800046b2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800046b4:	0c07c463          	bltz	a5,8000477c <sys_exec+0xec>
    800046b8:	f726                	sd	s1,424(sp)
    800046ba:	f34a                	sd	s2,416(sp)
    800046bc:	ef4e                	sd	s3,408(sp)
    800046be:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800046c0:	10000613          	li	a2,256
    800046c4:	4581                	li	a1,0
    800046c6:	e5040513          	addi	a0,s0,-432
    800046ca:	a85fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800046ce:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800046d2:	89a6                	mv	s3,s1
    800046d4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800046d6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800046da:	00391513          	slli	a0,s2,0x3
    800046de:	e4040593          	addi	a1,s0,-448
    800046e2:	e4843783          	ld	a5,-440(s0)
    800046e6:	953e                	add	a0,a0,a5
    800046e8:	ca2fd0ef          	jal	80001b8a <fetchaddr>
    800046ec:	02054663          	bltz	a0,80004718 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800046f0:	e4043783          	ld	a5,-448(s0)
    800046f4:	c3a9                	beqz	a5,80004736 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800046f6:	a09fb0ef          	jal	800000fe <kalloc>
    800046fa:	85aa                	mv	a1,a0
    800046fc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004700:	cd01                	beqz	a0,80004718 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004702:	6605                	lui	a2,0x1
    80004704:	e4043503          	ld	a0,-448(s0)
    80004708:	cccfd0ef          	jal	80001bd4 <fetchstr>
    8000470c:	00054663          	bltz	a0,80004718 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004710:	0905                	addi	s2,s2,1
    80004712:	09a1                	addi	s3,s3,8
    80004714:	fd4913e3          	bne	s2,s4,800046da <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004718:	f5040913          	addi	s2,s0,-176
    8000471c:	6088                	ld	a0,0(s1)
    8000471e:	c931                	beqz	a0,80004772 <sys_exec+0xe2>
    kfree(argv[i]);
    80004720:	8fdfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004724:	04a1                	addi	s1,s1,8
    80004726:	ff249be3          	bne	s1,s2,8000471c <sys_exec+0x8c>
  return -1;
    8000472a:	557d                	li	a0,-1
    8000472c:	74ba                	ld	s1,424(sp)
    8000472e:	791a                	ld	s2,416(sp)
    80004730:	69fa                	ld	s3,408(sp)
    80004732:	6a5a                	ld	s4,400(sp)
    80004734:	a0a1                	j	8000477c <sys_exec+0xec>
      argv[i] = 0;
    80004736:	0009079b          	sext.w	a5,s2
    8000473a:	078e                	slli	a5,a5,0x3
    8000473c:	fd078793          	addi	a5,a5,-48
    80004740:	97a2                	add	a5,a5,s0
    80004742:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004746:	e5040593          	addi	a1,s0,-432
    8000474a:	f5040513          	addi	a0,s0,-176
    8000474e:	ae6ff0ef          	jal	80003a34 <exec>
    80004752:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004754:	f5040993          	addi	s3,s0,-176
    80004758:	6088                	ld	a0,0(s1)
    8000475a:	c511                	beqz	a0,80004766 <sys_exec+0xd6>
    kfree(argv[i]);
    8000475c:	8c1fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004760:	04a1                	addi	s1,s1,8
    80004762:	ff349be3          	bne	s1,s3,80004758 <sys_exec+0xc8>
  return ret;
    80004766:	854a                	mv	a0,s2
    80004768:	74ba                	ld	s1,424(sp)
    8000476a:	791a                	ld	s2,416(sp)
    8000476c:	69fa                	ld	s3,408(sp)
    8000476e:	6a5a                	ld	s4,400(sp)
    80004770:	a031                	j	8000477c <sys_exec+0xec>
  return -1;
    80004772:	557d                	li	a0,-1
    80004774:	74ba                	ld	s1,424(sp)
    80004776:	791a                	ld	s2,416(sp)
    80004778:	69fa                	ld	s3,408(sp)
    8000477a:	6a5a                	ld	s4,400(sp)
}
    8000477c:	70fa                	ld	ra,440(sp)
    8000477e:	745a                	ld	s0,432(sp)
    80004780:	6139                	addi	sp,sp,448
    80004782:	8082                	ret

0000000080004784 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004784:	7139                	addi	sp,sp,-64
    80004786:	fc06                	sd	ra,56(sp)
    80004788:	f822                	sd	s0,48(sp)
    8000478a:	f426                	sd	s1,40(sp)
    8000478c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000478e:	dd8fc0ef          	jal	80000d66 <myproc>
    80004792:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004794:	fd840593          	addi	a1,s0,-40
    80004798:	4501                	li	a0,0
    8000479a:	c96fd0ef          	jal	80001c30 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000479e:	fc840593          	addi	a1,s0,-56
    800047a2:	fd040513          	addi	a0,s0,-48
    800047a6:	f9bfe0ef          	jal	80003740 <pipealloc>
    return -1;
    800047aa:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800047ac:	0a054463          	bltz	a0,80004854 <sys_pipe+0xd0>
  fd0 = -1;
    800047b0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800047b4:	fd043503          	ld	a0,-48(s0)
    800047b8:	e46ff0ef          	jal	80003dfe <fdalloc>
    800047bc:	fca42223          	sw	a0,-60(s0)
    800047c0:	08054163          	bltz	a0,80004842 <sys_pipe+0xbe>
    800047c4:	fc843503          	ld	a0,-56(s0)
    800047c8:	e36ff0ef          	jal	80003dfe <fdalloc>
    800047cc:	fca42023          	sw	a0,-64(s0)
    800047d0:	06054063          	bltz	a0,80004830 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047d4:	4691                	li	a3,4
    800047d6:	fc440613          	addi	a2,s0,-60
    800047da:	fd843583          	ld	a1,-40(s0)
    800047de:	68a8                	ld	a0,80(s1)
    800047e0:	9f8fc0ef          	jal	800009d8 <copyout>
    800047e4:	00054e63          	bltz	a0,80004800 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800047e8:	4691                	li	a3,4
    800047ea:	fc040613          	addi	a2,s0,-64
    800047ee:	fd843583          	ld	a1,-40(s0)
    800047f2:	0591                	addi	a1,a1,4
    800047f4:	68a8                	ld	a0,80(s1)
    800047f6:	9e2fc0ef          	jal	800009d8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047fa:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047fc:	04055c63          	bgez	a0,80004854 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004800:	fc442783          	lw	a5,-60(s0)
    80004804:	07e9                	addi	a5,a5,26
    80004806:	078e                	slli	a5,a5,0x3
    80004808:	97a6                	add	a5,a5,s1
    8000480a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000480e:	fc042783          	lw	a5,-64(s0)
    80004812:	07e9                	addi	a5,a5,26
    80004814:	078e                	slli	a5,a5,0x3
    80004816:	94be                	add	s1,s1,a5
    80004818:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000481c:	fd043503          	ld	a0,-48(s0)
    80004820:	c17fe0ef          	jal	80003436 <fileclose>
    fileclose(wf);
    80004824:	fc843503          	ld	a0,-56(s0)
    80004828:	c0ffe0ef          	jal	80003436 <fileclose>
    return -1;
    8000482c:	57fd                	li	a5,-1
    8000482e:	a01d                	j	80004854 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004830:	fc442783          	lw	a5,-60(s0)
    80004834:	0007c763          	bltz	a5,80004842 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004838:	07e9                	addi	a5,a5,26
    8000483a:	078e                	slli	a5,a5,0x3
    8000483c:	97a6                	add	a5,a5,s1
    8000483e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004842:	fd043503          	ld	a0,-48(s0)
    80004846:	bf1fe0ef          	jal	80003436 <fileclose>
    fileclose(wf);
    8000484a:	fc843503          	ld	a0,-56(s0)
    8000484e:	be9fe0ef          	jal	80003436 <fileclose>
    return -1;
    80004852:	57fd                	li	a5,-1
}
    80004854:	853e                	mv	a0,a5
    80004856:	70e2                	ld	ra,56(sp)
    80004858:	7442                	ld	s0,48(sp)
    8000485a:	74a2                	ld	s1,40(sp)
    8000485c:	6121                	addi	sp,sp,64
    8000485e:	8082                	ret

0000000080004860 <sys_symlink>:

//----------------------------------------------------------------------------
// Step 3 : Add this for creating symbolic links based on the instructions. 
uint64
sys_symlink(void)
{ 
    80004860:	7169                	addi	sp,sp,-304
    80004862:	f606                	sd	ra,296(sp)
    80004864:	f222                	sd	s0,288(sp)
    80004866:	1a00                	addi	s0,sp,304
  char  target[MAXPATH], path[MAXPATH];

  struct inode *ip;

  // Fetch the arguments (target and path) from the system call
  if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80004868:	08000613          	li	a2,128
    8000486c:	f6040593          	addi	a1,s0,-160
    80004870:	4501                	li	a0,0
    80004872:	bdafd0ef          	jal	80001c4c <argstr>
    return -1;
    80004876:	57fd                	li	a5,-1
  if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80004878:	06054763          	bltz	a0,800048e6 <sys_symlink+0x86>
    8000487c:	08000613          	li	a2,128
    80004880:	ee040593          	addi	a1,s0,-288
    80004884:	4505                	li	a0,1
    80004886:	bc6fd0ef          	jal	80001c4c <argstr>
    return -1;
    8000488a:	57fd                	li	a5,-1
  if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    8000488c:	04054d63          	bltz	a0,800048e6 <sys_symlink+0x86>
    80004890:	ee26                	sd	s1,280(sp)

  begin_op();
    80004892:	f8afe0ef          	jal	8000301c <begin_op>

  // Create the symlink like sys_open line 320 and also lock it
  if((ip =  create(path,T_SYMLINK,0,0))==0)
    80004896:	4681                	li	a3,0
    80004898:	4601                	li	a2,0
    8000489a:	4591                	li	a1,4
    8000489c:	ee040513          	addi	a0,s0,-288
    800048a0:	d9cff0ef          	jal	80003e3c <create>
    800048a4:	84aa                	mv	s1,a0
    800048a6:	c529                	beqz	a0,800048f0 <sys_symlink+0x90>
      3. We write the actual string target to the file, immediately after the length.
      4. Unlocks and releases the inode.

  */

  int len = strlen(target);                       //(Step 1)
    800048a8:	f6040513          	addi	a0,s0,-160
    800048ac:	a13fb0ef          	jal	800002be <strlen>
    800048b0:	eca42e23          	sw	a0,-292(s0)
  writei(ip,0,(uint64)&len,0,sizeof(len));        //(Step 2)
    800048b4:	4711                	li	a4,4
    800048b6:	4681                	li	a3,0
    800048b8:	edc40613          	addi	a2,s0,-292
    800048bc:	4581                	li	a1,0
    800048be:	8526                	mv	a0,s1
    800048c0:	a14fe0ef          	jal	80002ad4 <writei>
  writei(ip,0,(uint64)target,sizeof(len),len+1);  //(Step 3)
    800048c4:	edc42703          	lw	a4,-292(s0)
    800048c8:	2705                	addiw	a4,a4,1
    800048ca:	4691                	li	a3,4
    800048cc:	f6040613          	addi	a2,s0,-160
    800048d0:	4581                	li	a1,0
    800048d2:	8526                	mv	a0,s1
    800048d4:	a00fe0ef          	jal	80002ad4 <writei>
  iunlockput(ip);                                 //(Step 4)
    800048d8:	8526                	mv	a0,s1
    800048da:	8b4fe0ef          	jal	8000298e <iunlockput>
  
  end_op();
    800048de:	fa8fe0ef          	jal	80003086 <end_op>
  return 0;
    800048e2:	4781                	li	a5,0
    800048e4:	64f2                	ld	s1,280(sp)
}
    800048e6:	853e                	mv	a0,a5
    800048e8:	70b2                	ld	ra,296(sp)
    800048ea:	7412                	ld	s0,288(sp)
    800048ec:	6155                	addi	sp,sp,304
    800048ee:	8082                	ret
    end_op();
    800048f0:	f96fe0ef          	jal	80003086 <end_op>
    return -1;
    800048f4:	57fd                	li	a5,-1
    800048f6:	64f2                	ld	s1,280(sp)
    800048f8:	b7fd                	j	800048e6 <sys_symlink+0x86>
    800048fa:	0000                	unimp
    800048fc:	0000                	unimp
	...

0000000080004900 <kernelvec>:
    80004900:	7111                	addi	sp,sp,-256
    80004902:	e006                	sd	ra,0(sp)
    80004904:	e40a                	sd	sp,8(sp)
    80004906:	e80e                	sd	gp,16(sp)
    80004908:	ec12                	sd	tp,24(sp)
    8000490a:	f016                	sd	t0,32(sp)
    8000490c:	f41a                	sd	t1,40(sp)
    8000490e:	f81e                	sd	t2,48(sp)
    80004910:	e4aa                	sd	a0,72(sp)
    80004912:	e8ae                	sd	a1,80(sp)
    80004914:	ecb2                	sd	a2,88(sp)
    80004916:	f0b6                	sd	a3,96(sp)
    80004918:	f4ba                	sd	a4,104(sp)
    8000491a:	f8be                	sd	a5,112(sp)
    8000491c:	fcc2                	sd	a6,120(sp)
    8000491e:	e146                	sd	a7,128(sp)
    80004920:	edf2                	sd	t3,216(sp)
    80004922:	f1f6                	sd	t4,224(sp)
    80004924:	f5fa                	sd	t5,232(sp)
    80004926:	f9fe                	sd	t6,240(sp)
    80004928:	972fd0ef          	jal	80001a9a <kerneltrap>
    8000492c:	6082                	ld	ra,0(sp)
    8000492e:	6122                	ld	sp,8(sp)
    80004930:	61c2                	ld	gp,16(sp)
    80004932:	7282                	ld	t0,32(sp)
    80004934:	7322                	ld	t1,40(sp)
    80004936:	73c2                	ld	t2,48(sp)
    80004938:	6526                	ld	a0,72(sp)
    8000493a:	65c6                	ld	a1,80(sp)
    8000493c:	6666                	ld	a2,88(sp)
    8000493e:	7686                	ld	a3,96(sp)
    80004940:	7726                	ld	a4,104(sp)
    80004942:	77c6                	ld	a5,112(sp)
    80004944:	7866                	ld	a6,120(sp)
    80004946:	688a                	ld	a7,128(sp)
    80004948:	6e6e                	ld	t3,216(sp)
    8000494a:	7e8e                	ld	t4,224(sp)
    8000494c:	7f2e                	ld	t5,232(sp)
    8000494e:	7fce                	ld	t6,240(sp)
    80004950:	6111                	addi	sp,sp,256
    80004952:	10200073          	sret
	...

000000008000495e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000495e:	1141                	addi	sp,sp,-16
    80004960:	e422                	sd	s0,8(sp)
    80004962:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004964:	0c0007b7          	lui	a5,0xc000
    80004968:	4705                	li	a4,1
    8000496a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000496c:	0c0007b7          	lui	a5,0xc000
    80004970:	c3d8                	sw	a4,4(a5)
}
    80004972:	6422                	ld	s0,8(sp)
    80004974:	0141                	addi	sp,sp,16
    80004976:	8082                	ret

0000000080004978 <plicinithart>:

void
plicinithart(void)
{
    80004978:	1141                	addi	sp,sp,-16
    8000497a:	e406                	sd	ra,8(sp)
    8000497c:	e022                	sd	s0,0(sp)
    8000497e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004980:	bbafc0ef          	jal	80000d3a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004984:	0085171b          	slliw	a4,a0,0x8
    80004988:	0c0027b7          	lui	a5,0xc002
    8000498c:	97ba                	add	a5,a5,a4
    8000498e:	40200713          	li	a4,1026
    80004992:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004996:	00d5151b          	slliw	a0,a0,0xd
    8000499a:	0c2017b7          	lui	a5,0xc201
    8000499e:	97aa                	add	a5,a5,a0
    800049a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800049a4:	60a2                	ld	ra,8(sp)
    800049a6:	6402                	ld	s0,0(sp)
    800049a8:	0141                	addi	sp,sp,16
    800049aa:	8082                	ret

00000000800049ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800049ac:	1141                	addi	sp,sp,-16
    800049ae:	e406                	sd	ra,8(sp)
    800049b0:	e022                	sd	s0,0(sp)
    800049b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049b4:	b86fc0ef          	jal	80000d3a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800049b8:	00d5151b          	slliw	a0,a0,0xd
    800049bc:	0c2017b7          	lui	a5,0xc201
    800049c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800049c2:	43c8                	lw	a0,4(a5)
    800049c4:	60a2                	ld	ra,8(sp)
    800049c6:	6402                	ld	s0,0(sp)
    800049c8:	0141                	addi	sp,sp,16
    800049ca:	8082                	ret

00000000800049cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800049cc:	1101                	addi	sp,sp,-32
    800049ce:	ec06                	sd	ra,24(sp)
    800049d0:	e822                	sd	s0,16(sp)
    800049d2:	e426                	sd	s1,8(sp)
    800049d4:	1000                	addi	s0,sp,32
    800049d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800049d8:	b62fc0ef          	jal	80000d3a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800049dc:	00d5151b          	slliw	a0,a0,0xd
    800049e0:	0c2017b7          	lui	a5,0xc201
    800049e4:	97aa                	add	a5,a5,a0
    800049e6:	c3c4                	sw	s1,4(a5)
}
    800049e8:	60e2                	ld	ra,24(sp)
    800049ea:	6442                	ld	s0,16(sp)
    800049ec:	64a2                	ld	s1,8(sp)
    800049ee:	6105                	addi	sp,sp,32
    800049f0:	8082                	ret

00000000800049f2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800049f2:	1141                	addi	sp,sp,-16
    800049f4:	e406                	sd	ra,8(sp)
    800049f6:	e022                	sd	s0,0(sp)
    800049f8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800049fa:	479d                	li	a5,7
    800049fc:	04a7ca63          	blt	a5,a0,80004a50 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a00:	00012797          	auipc	a5,0x12
    80004a04:	dc078793          	addi	a5,a5,-576 # 800167c0 <disk>
    80004a08:	97aa                	add	a5,a5,a0
    80004a0a:	0187c783          	lbu	a5,24(a5)
    80004a0e:	e7b9                	bnez	a5,80004a5c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a10:	00451693          	slli	a3,a0,0x4
    80004a14:	00012797          	auipc	a5,0x12
    80004a18:	dac78793          	addi	a5,a5,-596 # 800167c0 <disk>
    80004a1c:	6398                	ld	a4,0(a5)
    80004a1e:	9736                	add	a4,a4,a3
    80004a20:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004a24:	6398                	ld	a4,0(a5)
    80004a26:	9736                	add	a4,a4,a3
    80004a28:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004a2c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004a30:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004a34:	97aa                	add	a5,a5,a0
    80004a36:	4705                	li	a4,1
    80004a38:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004a3c:	00012517          	auipc	a0,0x12
    80004a40:	d9c50513          	addi	a0,a0,-612 # 800167d8 <disk+0x18>
    80004a44:	93dfc0ef          	jal	80001380 <wakeup>
}
    80004a48:	60a2                	ld	ra,8(sp)
    80004a4a:	6402                	ld	s0,0(sp)
    80004a4c:	0141                	addi	sp,sp,16
    80004a4e:	8082                	ret
    panic("free_desc 1");
    80004a50:	00003517          	auipc	a0,0x3
    80004a54:	bc050513          	addi	a0,a0,-1088 # 80007610 <etext+0x610>
    80004a58:	43b000ef          	jal	80005692 <panic>
    panic("free_desc 2");
    80004a5c:	00003517          	auipc	a0,0x3
    80004a60:	bc450513          	addi	a0,a0,-1084 # 80007620 <etext+0x620>
    80004a64:	42f000ef          	jal	80005692 <panic>

0000000080004a68 <virtio_disk_init>:
{
    80004a68:	1101                	addi	sp,sp,-32
    80004a6a:	ec06                	sd	ra,24(sp)
    80004a6c:	e822                	sd	s0,16(sp)
    80004a6e:	e426                	sd	s1,8(sp)
    80004a70:	e04a                	sd	s2,0(sp)
    80004a72:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004a74:	00003597          	auipc	a1,0x3
    80004a78:	bbc58593          	addi	a1,a1,-1092 # 80007630 <etext+0x630>
    80004a7c:	00012517          	auipc	a0,0x12
    80004a80:	e6c50513          	addi	a0,a0,-404 # 800168e8 <disk+0x128>
    80004a84:	6bd000ef          	jal	80005940 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a88:	100017b7          	lui	a5,0x10001
    80004a8c:	4398                	lw	a4,0(a5)
    80004a8e:	2701                	sext.w	a4,a4
    80004a90:	747277b7          	lui	a5,0x74727
    80004a94:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004a98:	18f71063          	bne	a4,a5,80004c18 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a9c:	100017b7          	lui	a5,0x10001
    80004aa0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004aa2:	439c                	lw	a5,0(a5)
    80004aa4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004aa6:	4709                	li	a4,2
    80004aa8:	16e79863          	bne	a5,a4,80004c18 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004aac:	100017b7          	lui	a5,0x10001
    80004ab0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004ab2:	439c                	lw	a5,0(a5)
    80004ab4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004ab6:	16e79163          	bne	a5,a4,80004c18 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004aba:	100017b7          	lui	a5,0x10001
    80004abe:	47d8                	lw	a4,12(a5)
    80004ac0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004ac2:	554d47b7          	lui	a5,0x554d4
    80004ac6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004aca:	14f71763          	bne	a4,a5,80004c18 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ace:	100017b7          	lui	a5,0x10001
    80004ad2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ad6:	4705                	li	a4,1
    80004ad8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ada:	470d                	li	a4,3
    80004adc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004ade:	10001737          	lui	a4,0x10001
    80004ae2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004ae4:	c7ffe737          	lui	a4,0xc7ffe
    80004ae8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdfd5f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004aec:	8ef9                	and	a3,a3,a4
    80004aee:	10001737          	lui	a4,0x10001
    80004af2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004af4:	472d                	li	a4,11
    80004af6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004af8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004afc:	439c                	lw	a5,0(a5)
    80004afe:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b02:	8ba1                	andi	a5,a5,8
    80004b04:	12078063          	beqz	a5,80004c24 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b08:	100017b7          	lui	a5,0x10001
    80004b0c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b10:	100017b7          	lui	a5,0x10001
    80004b14:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004b18:	439c                	lw	a5,0(a5)
    80004b1a:	2781                	sext.w	a5,a5
    80004b1c:	10079a63          	bnez	a5,80004c30 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004b20:	100017b7          	lui	a5,0x10001
    80004b24:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004b28:	439c                	lw	a5,0(a5)
    80004b2a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004b2c:	10078863          	beqz	a5,80004c3c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004b30:	471d                	li	a4,7
    80004b32:	10f77b63          	bgeu	a4,a5,80004c48 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004b36:	dc8fb0ef          	jal	800000fe <kalloc>
    80004b3a:	00012497          	auipc	s1,0x12
    80004b3e:	c8648493          	addi	s1,s1,-890 # 800167c0 <disk>
    80004b42:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004b44:	dbafb0ef          	jal	800000fe <kalloc>
    80004b48:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004b4a:	db4fb0ef          	jal	800000fe <kalloc>
    80004b4e:	87aa                	mv	a5,a0
    80004b50:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004b52:	6088                	ld	a0,0(s1)
    80004b54:	10050063          	beqz	a0,80004c54 <virtio_disk_init+0x1ec>
    80004b58:	00012717          	auipc	a4,0x12
    80004b5c:	c7073703          	ld	a4,-912(a4) # 800167c8 <disk+0x8>
    80004b60:	0e070a63          	beqz	a4,80004c54 <virtio_disk_init+0x1ec>
    80004b64:	0e078863          	beqz	a5,80004c54 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004b68:	6605                	lui	a2,0x1
    80004b6a:	4581                	li	a1,0
    80004b6c:	de2fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004b70:	00012497          	auipc	s1,0x12
    80004b74:	c5048493          	addi	s1,s1,-944 # 800167c0 <disk>
    80004b78:	6605                	lui	a2,0x1
    80004b7a:	4581                	li	a1,0
    80004b7c:	6488                	ld	a0,8(s1)
    80004b7e:	dd0fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004b82:	6605                	lui	a2,0x1
    80004b84:	4581                	li	a1,0
    80004b86:	6888                	ld	a0,16(s1)
    80004b88:	dc6fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004b8c:	100017b7          	lui	a5,0x10001
    80004b90:	4721                	li	a4,8
    80004b92:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004b94:	4098                	lw	a4,0(s1)
    80004b96:	100017b7          	lui	a5,0x10001
    80004b9a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004b9e:	40d8                	lw	a4,4(s1)
    80004ba0:	100017b7          	lui	a5,0x10001
    80004ba4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004ba8:	649c                	ld	a5,8(s1)
    80004baa:	0007869b          	sext.w	a3,a5
    80004bae:	10001737          	lui	a4,0x10001
    80004bb2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004bb6:	9781                	srai	a5,a5,0x20
    80004bb8:	10001737          	lui	a4,0x10001
    80004bbc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004bc0:	689c                	ld	a5,16(s1)
    80004bc2:	0007869b          	sext.w	a3,a5
    80004bc6:	10001737          	lui	a4,0x10001
    80004bca:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004bce:	9781                	srai	a5,a5,0x20
    80004bd0:	10001737          	lui	a4,0x10001
    80004bd4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004bd8:	10001737          	lui	a4,0x10001
    80004bdc:	4785                	li	a5,1
    80004bde:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004be0:	00f48c23          	sb	a5,24(s1)
    80004be4:	00f48ca3          	sb	a5,25(s1)
    80004be8:	00f48d23          	sb	a5,26(s1)
    80004bec:	00f48da3          	sb	a5,27(s1)
    80004bf0:	00f48e23          	sb	a5,28(s1)
    80004bf4:	00f48ea3          	sb	a5,29(s1)
    80004bf8:	00f48f23          	sb	a5,30(s1)
    80004bfc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c00:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c04:	100017b7          	lui	a5,0x10001
    80004c08:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004c0c:	60e2                	ld	ra,24(sp)
    80004c0e:	6442                	ld	s0,16(sp)
    80004c10:	64a2                	ld	s1,8(sp)
    80004c12:	6902                	ld	s2,0(sp)
    80004c14:	6105                	addi	sp,sp,32
    80004c16:	8082                	ret
    panic("could not find virtio disk");
    80004c18:	00003517          	auipc	a0,0x3
    80004c1c:	a2850513          	addi	a0,a0,-1496 # 80007640 <etext+0x640>
    80004c20:	273000ef          	jal	80005692 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004c24:	00003517          	auipc	a0,0x3
    80004c28:	a3c50513          	addi	a0,a0,-1476 # 80007660 <etext+0x660>
    80004c2c:	267000ef          	jal	80005692 <panic>
    panic("virtio disk should not be ready");
    80004c30:	00003517          	auipc	a0,0x3
    80004c34:	a5050513          	addi	a0,a0,-1456 # 80007680 <etext+0x680>
    80004c38:	25b000ef          	jal	80005692 <panic>
    panic("virtio disk has no queue 0");
    80004c3c:	00003517          	auipc	a0,0x3
    80004c40:	a6450513          	addi	a0,a0,-1436 # 800076a0 <etext+0x6a0>
    80004c44:	24f000ef          	jal	80005692 <panic>
    panic("virtio disk max queue too short");
    80004c48:	00003517          	auipc	a0,0x3
    80004c4c:	a7850513          	addi	a0,a0,-1416 # 800076c0 <etext+0x6c0>
    80004c50:	243000ef          	jal	80005692 <panic>
    panic("virtio disk kalloc");
    80004c54:	00003517          	auipc	a0,0x3
    80004c58:	a8c50513          	addi	a0,a0,-1396 # 800076e0 <etext+0x6e0>
    80004c5c:	237000ef          	jal	80005692 <panic>

0000000080004c60 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004c60:	7159                	addi	sp,sp,-112
    80004c62:	f486                	sd	ra,104(sp)
    80004c64:	f0a2                	sd	s0,96(sp)
    80004c66:	eca6                	sd	s1,88(sp)
    80004c68:	e8ca                	sd	s2,80(sp)
    80004c6a:	e4ce                	sd	s3,72(sp)
    80004c6c:	e0d2                	sd	s4,64(sp)
    80004c6e:	fc56                	sd	s5,56(sp)
    80004c70:	f85a                	sd	s6,48(sp)
    80004c72:	f45e                	sd	s7,40(sp)
    80004c74:	f062                	sd	s8,32(sp)
    80004c76:	ec66                	sd	s9,24(sp)
    80004c78:	1880                	addi	s0,sp,112
    80004c7a:	8a2a                	mv	s4,a0
    80004c7c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004c7e:	00c52c83          	lw	s9,12(a0)
    80004c82:	001c9c9b          	slliw	s9,s9,0x1
    80004c86:	1c82                	slli	s9,s9,0x20
    80004c88:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004c8c:	00012517          	auipc	a0,0x12
    80004c90:	c5c50513          	addi	a0,a0,-932 # 800168e8 <disk+0x128>
    80004c94:	52d000ef          	jal	800059c0 <acquire>
  for(int i = 0; i < 3; i++){
    80004c98:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004c9a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004c9c:	00012b17          	auipc	s6,0x12
    80004ca0:	b24b0b13          	addi	s6,s6,-1244 # 800167c0 <disk>
  for(int i = 0; i < 3; i++){
    80004ca4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004ca6:	00012c17          	auipc	s8,0x12
    80004caa:	c42c0c13          	addi	s8,s8,-958 # 800168e8 <disk+0x128>
    80004cae:	a8b9                	j	80004d0c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004cb0:	00fb0733          	add	a4,s6,a5
    80004cb4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004cb8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004cba:	0207c563          	bltz	a5,80004ce4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004cbe:	2905                	addiw	s2,s2,1
    80004cc0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004cc2:	05590963          	beq	s2,s5,80004d14 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004cc6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004cc8:	00012717          	auipc	a4,0x12
    80004ccc:	af870713          	addi	a4,a4,-1288 # 800167c0 <disk>
    80004cd0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004cd2:	01874683          	lbu	a3,24(a4)
    80004cd6:	fee9                	bnez	a3,80004cb0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004cd8:	2785                	addiw	a5,a5,1
    80004cda:	0705                	addi	a4,a4,1
    80004cdc:	fe979be3          	bne	a5,s1,80004cd2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004ce0:	57fd                	li	a5,-1
    80004ce2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004ce4:	01205d63          	blez	s2,80004cfe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004ce8:	f9042503          	lw	a0,-112(s0)
    80004cec:	d07ff0ef          	jal	800049f2 <free_desc>
      for(int j = 0; j < i; j++)
    80004cf0:	4785                	li	a5,1
    80004cf2:	0127d663          	bge	a5,s2,80004cfe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004cf6:	f9442503          	lw	a0,-108(s0)
    80004cfa:	cf9ff0ef          	jal	800049f2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004cfe:	85e2                	mv	a1,s8
    80004d00:	00012517          	auipc	a0,0x12
    80004d04:	ad850513          	addi	a0,a0,-1320 # 800167d8 <disk+0x18>
    80004d08:	e2cfc0ef          	jal	80001334 <sleep>
  for(int i = 0; i < 3; i++){
    80004d0c:	f9040613          	addi	a2,s0,-112
    80004d10:	894e                	mv	s2,s3
    80004d12:	bf55                	j	80004cc6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d14:	f9042503          	lw	a0,-112(s0)
    80004d18:	00451693          	slli	a3,a0,0x4

  if(write)
    80004d1c:	00012797          	auipc	a5,0x12
    80004d20:	aa478793          	addi	a5,a5,-1372 # 800167c0 <disk>
    80004d24:	00a50713          	addi	a4,a0,10
    80004d28:	0712                	slli	a4,a4,0x4
    80004d2a:	973e                	add	a4,a4,a5
    80004d2c:	01703633          	snez	a2,s7
    80004d30:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004d32:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004d36:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d3a:	6398                	ld	a4,0(a5)
    80004d3c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d3e:	0a868613          	addi	a2,a3,168
    80004d42:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d44:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004d46:	6390                	ld	a2,0(a5)
    80004d48:	00d605b3          	add	a1,a2,a3
    80004d4c:	4741                	li	a4,16
    80004d4e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004d50:	4805                	li	a6,1
    80004d52:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004d56:	f9442703          	lw	a4,-108(s0)
    80004d5a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004d5e:	0712                	slli	a4,a4,0x4
    80004d60:	963a                	add	a2,a2,a4
    80004d62:	058a0593          	addi	a1,s4,88
    80004d66:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004d68:	0007b883          	ld	a7,0(a5)
    80004d6c:	9746                	add	a4,a4,a7
    80004d6e:	40000613          	li	a2,1024
    80004d72:	c710                	sw	a2,8(a4)
  if(write)
    80004d74:	001bb613          	seqz	a2,s7
    80004d78:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004d7c:	00166613          	ori	a2,a2,1
    80004d80:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004d84:	f9842583          	lw	a1,-104(s0)
    80004d88:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004d8c:	00250613          	addi	a2,a0,2
    80004d90:	0612                	slli	a2,a2,0x4
    80004d92:	963e                	add	a2,a2,a5
    80004d94:	577d                	li	a4,-1
    80004d96:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004d9a:	0592                	slli	a1,a1,0x4
    80004d9c:	98ae                	add	a7,a7,a1
    80004d9e:	03068713          	addi	a4,a3,48
    80004da2:	973e                	add	a4,a4,a5
    80004da4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004da8:	6398                	ld	a4,0(a5)
    80004daa:	972e                	add	a4,a4,a1
    80004dac:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004db0:	4689                	li	a3,2
    80004db2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004db6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004dba:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004dbe:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004dc2:	6794                	ld	a3,8(a5)
    80004dc4:	0026d703          	lhu	a4,2(a3)
    80004dc8:	8b1d                	andi	a4,a4,7
    80004dca:	0706                	slli	a4,a4,0x1
    80004dcc:	96ba                	add	a3,a3,a4
    80004dce:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004dd2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004dd6:	6798                	ld	a4,8(a5)
    80004dd8:	00275783          	lhu	a5,2(a4)
    80004ddc:	2785                	addiw	a5,a5,1
    80004dde:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004de2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004de6:	100017b7          	lui	a5,0x10001
    80004dea:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004dee:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004df2:	00012917          	auipc	s2,0x12
    80004df6:	af690913          	addi	s2,s2,-1290 # 800168e8 <disk+0x128>
  while(b->disk == 1) {
    80004dfa:	4485                	li	s1,1
    80004dfc:	01079a63          	bne	a5,a6,80004e10 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004e00:	85ca                	mv	a1,s2
    80004e02:	8552                	mv	a0,s4
    80004e04:	d30fc0ef          	jal	80001334 <sleep>
  while(b->disk == 1) {
    80004e08:	004a2783          	lw	a5,4(s4)
    80004e0c:	fe978ae3          	beq	a5,s1,80004e00 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004e10:	f9042903          	lw	s2,-112(s0)
    80004e14:	00290713          	addi	a4,s2,2
    80004e18:	0712                	slli	a4,a4,0x4
    80004e1a:	00012797          	auipc	a5,0x12
    80004e1e:	9a678793          	addi	a5,a5,-1626 # 800167c0 <disk>
    80004e22:	97ba                	add	a5,a5,a4
    80004e24:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004e28:	00012997          	auipc	s3,0x12
    80004e2c:	99898993          	addi	s3,s3,-1640 # 800167c0 <disk>
    80004e30:	00491713          	slli	a4,s2,0x4
    80004e34:	0009b783          	ld	a5,0(s3)
    80004e38:	97ba                	add	a5,a5,a4
    80004e3a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004e3e:	854a                	mv	a0,s2
    80004e40:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004e44:	bafff0ef          	jal	800049f2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004e48:	8885                	andi	s1,s1,1
    80004e4a:	f0fd                	bnez	s1,80004e30 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004e4c:	00012517          	auipc	a0,0x12
    80004e50:	a9c50513          	addi	a0,a0,-1380 # 800168e8 <disk+0x128>
    80004e54:	405000ef          	jal	80005a58 <release>
}
    80004e58:	70a6                	ld	ra,104(sp)
    80004e5a:	7406                	ld	s0,96(sp)
    80004e5c:	64e6                	ld	s1,88(sp)
    80004e5e:	6946                	ld	s2,80(sp)
    80004e60:	69a6                	ld	s3,72(sp)
    80004e62:	6a06                	ld	s4,64(sp)
    80004e64:	7ae2                	ld	s5,56(sp)
    80004e66:	7b42                	ld	s6,48(sp)
    80004e68:	7ba2                	ld	s7,40(sp)
    80004e6a:	7c02                	ld	s8,32(sp)
    80004e6c:	6ce2                	ld	s9,24(sp)
    80004e6e:	6165                	addi	sp,sp,112
    80004e70:	8082                	ret

0000000080004e72 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004e72:	1101                	addi	sp,sp,-32
    80004e74:	ec06                	sd	ra,24(sp)
    80004e76:	e822                	sd	s0,16(sp)
    80004e78:	e426                	sd	s1,8(sp)
    80004e7a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004e7c:	00012497          	auipc	s1,0x12
    80004e80:	94448493          	addi	s1,s1,-1724 # 800167c0 <disk>
    80004e84:	00012517          	auipc	a0,0x12
    80004e88:	a6450513          	addi	a0,a0,-1436 # 800168e8 <disk+0x128>
    80004e8c:	335000ef          	jal	800059c0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004e90:	100017b7          	lui	a5,0x10001
    80004e94:	53b8                	lw	a4,96(a5)
    80004e96:	8b0d                	andi	a4,a4,3
    80004e98:	100017b7          	lui	a5,0x10001
    80004e9c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004e9e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004ea2:	689c                	ld	a5,16(s1)
    80004ea4:	0204d703          	lhu	a4,32(s1)
    80004ea8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004eac:	04f70663          	beq	a4,a5,80004ef8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004eb0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004eb4:	6898                	ld	a4,16(s1)
    80004eb6:	0204d783          	lhu	a5,32(s1)
    80004eba:	8b9d                	andi	a5,a5,7
    80004ebc:	078e                	slli	a5,a5,0x3
    80004ebe:	97ba                	add	a5,a5,a4
    80004ec0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004ec2:	00278713          	addi	a4,a5,2
    80004ec6:	0712                	slli	a4,a4,0x4
    80004ec8:	9726                	add	a4,a4,s1
    80004eca:	01074703          	lbu	a4,16(a4)
    80004ece:	e321                	bnez	a4,80004f0e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004ed0:	0789                	addi	a5,a5,2
    80004ed2:	0792                	slli	a5,a5,0x4
    80004ed4:	97a6                	add	a5,a5,s1
    80004ed6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004ed8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004edc:	ca4fc0ef          	jal	80001380 <wakeup>

    disk.used_idx += 1;
    80004ee0:	0204d783          	lhu	a5,32(s1)
    80004ee4:	2785                	addiw	a5,a5,1
    80004ee6:	17c2                	slli	a5,a5,0x30
    80004ee8:	93c1                	srli	a5,a5,0x30
    80004eea:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004eee:	6898                	ld	a4,16(s1)
    80004ef0:	00275703          	lhu	a4,2(a4)
    80004ef4:	faf71ee3          	bne	a4,a5,80004eb0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004ef8:	00012517          	auipc	a0,0x12
    80004efc:	9f050513          	addi	a0,a0,-1552 # 800168e8 <disk+0x128>
    80004f00:	359000ef          	jal	80005a58 <release>
}
    80004f04:	60e2                	ld	ra,24(sp)
    80004f06:	6442                	ld	s0,16(sp)
    80004f08:	64a2                	ld	s1,8(sp)
    80004f0a:	6105                	addi	sp,sp,32
    80004f0c:	8082                	ret
      panic("virtio_disk_intr status");
    80004f0e:	00002517          	auipc	a0,0x2
    80004f12:	7ea50513          	addi	a0,a0,2026 # 800076f8 <etext+0x6f8>
    80004f16:	77c000ef          	jal	80005692 <panic>

0000000080004f1a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004f1a:	1141                	addi	sp,sp,-16
    80004f1c:	e422                	sd	s0,8(sp)
    80004f1e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004f20:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004f24:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004f28:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004f2c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004f30:	577d                	li	a4,-1
    80004f32:	177e                	slli	a4,a4,0x3f
    80004f34:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004f36:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004f3a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004f3e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004f42:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004f46:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004f4a:	000f4737          	lui	a4,0xf4
    80004f4e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004f52:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004f54:	14d79073          	csrw	stimecmp,a5
}
    80004f58:	6422                	ld	s0,8(sp)
    80004f5a:	0141                	addi	sp,sp,16
    80004f5c:	8082                	ret

0000000080004f5e <start>:
{
    80004f5e:	1141                	addi	sp,sp,-16
    80004f60:	e406                	sd	ra,8(sp)
    80004f62:	e022                	sd	s0,0(sp)
    80004f64:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004f66:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004f6a:	7779                	lui	a4,0xffffe
    80004f6c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdfdff>
    80004f70:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004f72:	6705                	lui	a4,0x1
    80004f74:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004f78:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004f7a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004f7e:	ffffb797          	auipc	a5,0xffffb
    80004f82:	36a78793          	addi	a5,a5,874 # 800002e8 <main>
    80004f86:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004f8a:	4781                	li	a5,0
    80004f8c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004f90:	67c1                	lui	a5,0x10
    80004f92:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004f94:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004f98:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004f9c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004fa0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004fa4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004fa8:	57fd                	li	a5,-1
    80004faa:	83a9                	srli	a5,a5,0xa
    80004fac:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004fb0:	47bd                	li	a5,15
    80004fb2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004fb6:	f65ff0ef          	jal	80004f1a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004fba:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004fbe:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004fc0:	823e                	mv	tp,a5
  asm volatile("mret");
    80004fc2:	30200073          	mret
}
    80004fc6:	60a2                	ld	ra,8(sp)
    80004fc8:	6402                	ld	s0,0(sp)
    80004fca:	0141                	addi	sp,sp,16
    80004fcc:	8082                	ret

0000000080004fce <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004fce:	715d                	addi	sp,sp,-80
    80004fd0:	e486                	sd	ra,72(sp)
    80004fd2:	e0a2                	sd	s0,64(sp)
    80004fd4:	f84a                	sd	s2,48(sp)
    80004fd6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004fd8:	04c05263          	blez	a2,8000501c <consolewrite+0x4e>
    80004fdc:	fc26                	sd	s1,56(sp)
    80004fde:	f44e                	sd	s3,40(sp)
    80004fe0:	f052                	sd	s4,32(sp)
    80004fe2:	ec56                	sd	s5,24(sp)
    80004fe4:	8a2a                	mv	s4,a0
    80004fe6:	84ae                	mv	s1,a1
    80004fe8:	89b2                	mv	s3,a2
    80004fea:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004fec:	5afd                	li	s5,-1
    80004fee:	4685                	li	a3,1
    80004ff0:	8626                	mv	a2,s1
    80004ff2:	85d2                	mv	a1,s4
    80004ff4:	fbf40513          	addi	a0,s0,-65
    80004ff8:	edcfc0ef          	jal	800016d4 <either_copyin>
    80004ffc:	03550263          	beq	a0,s5,80005020 <consolewrite+0x52>
      break;
    uartputc(c);
    80005000:	fbf44503          	lbu	a0,-65(s0)
    80005004:	035000ef          	jal	80005838 <uartputc>
  for(i = 0; i < n; i++){
    80005008:	2905                	addiw	s2,s2,1
    8000500a:	0485                	addi	s1,s1,1
    8000500c:	ff2991e3          	bne	s3,s2,80004fee <consolewrite+0x20>
    80005010:	894e                	mv	s2,s3
    80005012:	74e2                	ld	s1,56(sp)
    80005014:	79a2                	ld	s3,40(sp)
    80005016:	7a02                	ld	s4,32(sp)
    80005018:	6ae2                	ld	s5,24(sp)
    8000501a:	a039                	j	80005028 <consolewrite+0x5a>
    8000501c:	4901                	li	s2,0
    8000501e:	a029                	j	80005028 <consolewrite+0x5a>
    80005020:	74e2                	ld	s1,56(sp)
    80005022:	79a2                	ld	s3,40(sp)
    80005024:	7a02                	ld	s4,32(sp)
    80005026:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005028:	854a                	mv	a0,s2
    8000502a:	60a6                	ld	ra,72(sp)
    8000502c:	6406                	ld	s0,64(sp)
    8000502e:	7942                	ld	s2,48(sp)
    80005030:	6161                	addi	sp,sp,80
    80005032:	8082                	ret

0000000080005034 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005034:	711d                	addi	sp,sp,-96
    80005036:	ec86                	sd	ra,88(sp)
    80005038:	e8a2                	sd	s0,80(sp)
    8000503a:	e4a6                	sd	s1,72(sp)
    8000503c:	e0ca                	sd	s2,64(sp)
    8000503e:	fc4e                	sd	s3,56(sp)
    80005040:	f852                	sd	s4,48(sp)
    80005042:	f456                	sd	s5,40(sp)
    80005044:	f05a                	sd	s6,32(sp)
    80005046:	1080                	addi	s0,sp,96
    80005048:	8aaa                	mv	s5,a0
    8000504a:	8a2e                	mv	s4,a1
    8000504c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000504e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005052:	0001a517          	auipc	a0,0x1a
    80005056:	8ae50513          	addi	a0,a0,-1874 # 8001e900 <cons>
    8000505a:	167000ef          	jal	800059c0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000505e:	0001a497          	auipc	s1,0x1a
    80005062:	8a248493          	addi	s1,s1,-1886 # 8001e900 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005066:	0001a917          	auipc	s2,0x1a
    8000506a:	93290913          	addi	s2,s2,-1742 # 8001e998 <cons+0x98>
  while(n > 0){
    8000506e:	0b305d63          	blez	s3,80005128 <consoleread+0xf4>
    while(cons.r == cons.w){
    80005072:	0984a783          	lw	a5,152(s1)
    80005076:	09c4a703          	lw	a4,156(s1)
    8000507a:	0af71263          	bne	a4,a5,8000511e <consoleread+0xea>
      if(killed(myproc())){
    8000507e:	ce9fb0ef          	jal	80000d66 <myproc>
    80005082:	ce4fc0ef          	jal	80001566 <killed>
    80005086:	e12d                	bnez	a0,800050e8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005088:	85a6                	mv	a1,s1
    8000508a:	854a                	mv	a0,s2
    8000508c:	aa8fc0ef          	jal	80001334 <sleep>
    while(cons.r == cons.w){
    80005090:	0984a783          	lw	a5,152(s1)
    80005094:	09c4a703          	lw	a4,156(s1)
    80005098:	fef703e3          	beq	a4,a5,8000507e <consoleread+0x4a>
    8000509c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000509e:	0001a717          	auipc	a4,0x1a
    800050a2:	86270713          	addi	a4,a4,-1950 # 8001e900 <cons>
    800050a6:	0017869b          	addiw	a3,a5,1
    800050aa:	08d72c23          	sw	a3,152(a4)
    800050ae:	07f7f693          	andi	a3,a5,127
    800050b2:	9736                	add	a4,a4,a3
    800050b4:	01874703          	lbu	a4,24(a4)
    800050b8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800050bc:	4691                	li	a3,4
    800050be:	04db8663          	beq	s7,a3,8000510a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800050c2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800050c6:	4685                	li	a3,1
    800050c8:	faf40613          	addi	a2,s0,-81
    800050cc:	85d2                	mv	a1,s4
    800050ce:	8556                	mv	a0,s5
    800050d0:	dbafc0ef          	jal	8000168a <either_copyout>
    800050d4:	57fd                	li	a5,-1
    800050d6:	04f50863          	beq	a0,a5,80005126 <consoleread+0xf2>
      break;

    dst++;
    800050da:	0a05                	addi	s4,s4,1
    --n;
    800050dc:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800050de:	47a9                	li	a5,10
    800050e0:	04fb8d63          	beq	s7,a5,8000513a <consoleread+0x106>
    800050e4:	6be2                	ld	s7,24(sp)
    800050e6:	b761                	j	8000506e <consoleread+0x3a>
        release(&cons.lock);
    800050e8:	0001a517          	auipc	a0,0x1a
    800050ec:	81850513          	addi	a0,a0,-2024 # 8001e900 <cons>
    800050f0:	169000ef          	jal	80005a58 <release>
        return -1;
    800050f4:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800050f6:	60e6                	ld	ra,88(sp)
    800050f8:	6446                	ld	s0,80(sp)
    800050fa:	64a6                	ld	s1,72(sp)
    800050fc:	6906                	ld	s2,64(sp)
    800050fe:	79e2                	ld	s3,56(sp)
    80005100:	7a42                	ld	s4,48(sp)
    80005102:	7aa2                	ld	s5,40(sp)
    80005104:	7b02                	ld	s6,32(sp)
    80005106:	6125                	addi	sp,sp,96
    80005108:	8082                	ret
      if(n < target){
    8000510a:	0009871b          	sext.w	a4,s3
    8000510e:	01677a63          	bgeu	a4,s6,80005122 <consoleread+0xee>
        cons.r--;
    80005112:	0001a717          	auipc	a4,0x1a
    80005116:	88f72323          	sw	a5,-1914(a4) # 8001e998 <cons+0x98>
    8000511a:	6be2                	ld	s7,24(sp)
    8000511c:	a031                	j	80005128 <consoleread+0xf4>
    8000511e:	ec5e                	sd	s7,24(sp)
    80005120:	bfbd                	j	8000509e <consoleread+0x6a>
    80005122:	6be2                	ld	s7,24(sp)
    80005124:	a011                	j	80005128 <consoleread+0xf4>
    80005126:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005128:	00019517          	auipc	a0,0x19
    8000512c:	7d850513          	addi	a0,a0,2008 # 8001e900 <cons>
    80005130:	129000ef          	jal	80005a58 <release>
  return target - n;
    80005134:	413b053b          	subw	a0,s6,s3
    80005138:	bf7d                	j	800050f6 <consoleread+0xc2>
    8000513a:	6be2                	ld	s7,24(sp)
    8000513c:	b7f5                	j	80005128 <consoleread+0xf4>

000000008000513e <consputc>:
{
    8000513e:	1141                	addi	sp,sp,-16
    80005140:	e406                	sd	ra,8(sp)
    80005142:	e022                	sd	s0,0(sp)
    80005144:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005146:	10000793          	li	a5,256
    8000514a:	00f50863          	beq	a0,a5,8000515a <consputc+0x1c>
    uartputc_sync(c);
    8000514e:	604000ef          	jal	80005752 <uartputc_sync>
}
    80005152:	60a2                	ld	ra,8(sp)
    80005154:	6402                	ld	s0,0(sp)
    80005156:	0141                	addi	sp,sp,16
    80005158:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000515a:	4521                	li	a0,8
    8000515c:	5f6000ef          	jal	80005752 <uartputc_sync>
    80005160:	02000513          	li	a0,32
    80005164:	5ee000ef          	jal	80005752 <uartputc_sync>
    80005168:	4521                	li	a0,8
    8000516a:	5e8000ef          	jal	80005752 <uartputc_sync>
    8000516e:	b7d5                	j	80005152 <consputc+0x14>

0000000080005170 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005170:	1101                	addi	sp,sp,-32
    80005172:	ec06                	sd	ra,24(sp)
    80005174:	e822                	sd	s0,16(sp)
    80005176:	e426                	sd	s1,8(sp)
    80005178:	1000                	addi	s0,sp,32
    8000517a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000517c:	00019517          	auipc	a0,0x19
    80005180:	78450513          	addi	a0,a0,1924 # 8001e900 <cons>
    80005184:	03d000ef          	jal	800059c0 <acquire>

  switch(c){
    80005188:	47d5                	li	a5,21
    8000518a:	08f48f63          	beq	s1,a5,80005228 <consoleintr+0xb8>
    8000518e:	0297c563          	blt	a5,s1,800051b8 <consoleintr+0x48>
    80005192:	47a1                	li	a5,8
    80005194:	0ef48463          	beq	s1,a5,8000527c <consoleintr+0x10c>
    80005198:	47c1                	li	a5,16
    8000519a:	10f49563          	bne	s1,a5,800052a4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000519e:	d80fc0ef          	jal	8000171e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800051a2:	00019517          	auipc	a0,0x19
    800051a6:	75e50513          	addi	a0,a0,1886 # 8001e900 <cons>
    800051aa:	0af000ef          	jal	80005a58 <release>
}
    800051ae:	60e2                	ld	ra,24(sp)
    800051b0:	6442                	ld	s0,16(sp)
    800051b2:	64a2                	ld	s1,8(sp)
    800051b4:	6105                	addi	sp,sp,32
    800051b6:	8082                	ret
  switch(c){
    800051b8:	07f00793          	li	a5,127
    800051bc:	0cf48063          	beq	s1,a5,8000527c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051c0:	00019717          	auipc	a4,0x19
    800051c4:	74070713          	addi	a4,a4,1856 # 8001e900 <cons>
    800051c8:	0a072783          	lw	a5,160(a4)
    800051cc:	09872703          	lw	a4,152(a4)
    800051d0:	9f99                	subw	a5,a5,a4
    800051d2:	07f00713          	li	a4,127
    800051d6:	fcf766e3          	bltu	a4,a5,800051a2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800051da:	47b5                	li	a5,13
    800051dc:	0cf48763          	beq	s1,a5,800052aa <consoleintr+0x13a>
      consputc(c);
    800051e0:	8526                	mv	a0,s1
    800051e2:	f5dff0ef          	jal	8000513e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800051e6:	00019797          	auipc	a5,0x19
    800051ea:	71a78793          	addi	a5,a5,1818 # 8001e900 <cons>
    800051ee:	0a07a683          	lw	a3,160(a5)
    800051f2:	0016871b          	addiw	a4,a3,1
    800051f6:	0007061b          	sext.w	a2,a4
    800051fa:	0ae7a023          	sw	a4,160(a5)
    800051fe:	07f6f693          	andi	a3,a3,127
    80005202:	97b6                	add	a5,a5,a3
    80005204:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005208:	47a9                	li	a5,10
    8000520a:	0cf48563          	beq	s1,a5,800052d4 <consoleintr+0x164>
    8000520e:	4791                	li	a5,4
    80005210:	0cf48263          	beq	s1,a5,800052d4 <consoleintr+0x164>
    80005214:	00019797          	auipc	a5,0x19
    80005218:	7847a783          	lw	a5,1924(a5) # 8001e998 <cons+0x98>
    8000521c:	9f1d                	subw	a4,a4,a5
    8000521e:	08000793          	li	a5,128
    80005222:	f8f710e3          	bne	a4,a5,800051a2 <consoleintr+0x32>
    80005226:	a07d                	j	800052d4 <consoleintr+0x164>
    80005228:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000522a:	00019717          	auipc	a4,0x19
    8000522e:	6d670713          	addi	a4,a4,1750 # 8001e900 <cons>
    80005232:	0a072783          	lw	a5,160(a4)
    80005236:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000523a:	00019497          	auipc	s1,0x19
    8000523e:	6c648493          	addi	s1,s1,1734 # 8001e900 <cons>
    while(cons.e != cons.w &&
    80005242:	4929                	li	s2,10
    80005244:	02f70863          	beq	a4,a5,80005274 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005248:	37fd                	addiw	a5,a5,-1
    8000524a:	07f7f713          	andi	a4,a5,127
    8000524e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005250:	01874703          	lbu	a4,24(a4)
    80005254:	03270263          	beq	a4,s2,80005278 <consoleintr+0x108>
      cons.e--;
    80005258:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000525c:	10000513          	li	a0,256
    80005260:	edfff0ef          	jal	8000513e <consputc>
    while(cons.e != cons.w &&
    80005264:	0a04a783          	lw	a5,160(s1)
    80005268:	09c4a703          	lw	a4,156(s1)
    8000526c:	fcf71ee3          	bne	a4,a5,80005248 <consoleintr+0xd8>
    80005270:	6902                	ld	s2,0(sp)
    80005272:	bf05                	j	800051a2 <consoleintr+0x32>
    80005274:	6902                	ld	s2,0(sp)
    80005276:	b735                	j	800051a2 <consoleintr+0x32>
    80005278:	6902                	ld	s2,0(sp)
    8000527a:	b725                	j	800051a2 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000527c:	00019717          	auipc	a4,0x19
    80005280:	68470713          	addi	a4,a4,1668 # 8001e900 <cons>
    80005284:	0a072783          	lw	a5,160(a4)
    80005288:	09c72703          	lw	a4,156(a4)
    8000528c:	f0f70be3          	beq	a4,a5,800051a2 <consoleintr+0x32>
      cons.e--;
    80005290:	37fd                	addiw	a5,a5,-1
    80005292:	00019717          	auipc	a4,0x19
    80005296:	70f72723          	sw	a5,1806(a4) # 8001e9a0 <cons+0xa0>
      consputc(BACKSPACE);
    8000529a:	10000513          	li	a0,256
    8000529e:	ea1ff0ef          	jal	8000513e <consputc>
    800052a2:	b701                	j	800051a2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800052a4:	ee048fe3          	beqz	s1,800051a2 <consoleintr+0x32>
    800052a8:	bf21                	j	800051c0 <consoleintr+0x50>
      consputc(c);
    800052aa:	4529                	li	a0,10
    800052ac:	e93ff0ef          	jal	8000513e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800052b0:	00019797          	auipc	a5,0x19
    800052b4:	65078793          	addi	a5,a5,1616 # 8001e900 <cons>
    800052b8:	0a07a703          	lw	a4,160(a5)
    800052bc:	0017069b          	addiw	a3,a4,1
    800052c0:	0006861b          	sext.w	a2,a3
    800052c4:	0ad7a023          	sw	a3,160(a5)
    800052c8:	07f77713          	andi	a4,a4,127
    800052cc:	97ba                	add	a5,a5,a4
    800052ce:	4729                	li	a4,10
    800052d0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800052d4:	00019797          	auipc	a5,0x19
    800052d8:	6cc7a423          	sw	a2,1736(a5) # 8001e99c <cons+0x9c>
        wakeup(&cons.r);
    800052dc:	00019517          	auipc	a0,0x19
    800052e0:	6bc50513          	addi	a0,a0,1724 # 8001e998 <cons+0x98>
    800052e4:	89cfc0ef          	jal	80001380 <wakeup>
    800052e8:	bd6d                	j	800051a2 <consoleintr+0x32>

00000000800052ea <consoleinit>:

void
consoleinit(void)
{
    800052ea:	1141                	addi	sp,sp,-16
    800052ec:	e406                	sd	ra,8(sp)
    800052ee:	e022                	sd	s0,0(sp)
    800052f0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800052f2:	00002597          	auipc	a1,0x2
    800052f6:	41e58593          	addi	a1,a1,1054 # 80007710 <etext+0x710>
    800052fa:	00019517          	auipc	a0,0x19
    800052fe:	60650513          	addi	a0,a0,1542 # 8001e900 <cons>
    80005302:	63e000ef          	jal	80005940 <initlock>

  uartinit();
    80005306:	3f4000ef          	jal	800056fa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000530a:	00010797          	auipc	a5,0x10
    8000530e:	45e78793          	addi	a5,a5,1118 # 80015768 <devsw>
    80005312:	00000717          	auipc	a4,0x0
    80005316:	d2270713          	addi	a4,a4,-734 # 80005034 <consoleread>
    8000531a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000531c:	00000717          	auipc	a4,0x0
    80005320:	cb270713          	addi	a4,a4,-846 # 80004fce <consolewrite>
    80005324:	ef98                	sd	a4,24(a5)
}
    80005326:	60a2                	ld	ra,8(sp)
    80005328:	6402                	ld	s0,0(sp)
    8000532a:	0141                	addi	sp,sp,16
    8000532c:	8082                	ret

000000008000532e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000532e:	7179                	addi	sp,sp,-48
    80005330:	f406                	sd	ra,40(sp)
    80005332:	f022                	sd	s0,32(sp)
    80005334:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005336:	c219                	beqz	a2,8000533c <printint+0xe>
    80005338:	08054063          	bltz	a0,800053b8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000533c:	4881                	li	a7,0
    8000533e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005342:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005344:	00002617          	auipc	a2,0x2
    80005348:	52c60613          	addi	a2,a2,1324 # 80007870 <digits>
    8000534c:	883e                	mv	a6,a5
    8000534e:	2785                	addiw	a5,a5,1
    80005350:	02b57733          	remu	a4,a0,a1
    80005354:	9732                	add	a4,a4,a2
    80005356:	00074703          	lbu	a4,0(a4)
    8000535a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000535e:	872a                	mv	a4,a0
    80005360:	02b55533          	divu	a0,a0,a1
    80005364:	0685                	addi	a3,a3,1
    80005366:	feb773e3          	bgeu	a4,a1,8000534c <printint+0x1e>

  if(sign)
    8000536a:	00088a63          	beqz	a7,8000537e <printint+0x50>
    buf[i++] = '-';
    8000536e:	1781                	addi	a5,a5,-32
    80005370:	97a2                	add	a5,a5,s0
    80005372:	02d00713          	li	a4,45
    80005376:	fee78823          	sb	a4,-16(a5)
    8000537a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000537e:	02f05963          	blez	a5,800053b0 <printint+0x82>
    80005382:	ec26                	sd	s1,24(sp)
    80005384:	e84a                	sd	s2,16(sp)
    80005386:	fd040713          	addi	a4,s0,-48
    8000538a:	00f704b3          	add	s1,a4,a5
    8000538e:	fff70913          	addi	s2,a4,-1
    80005392:	993e                	add	s2,s2,a5
    80005394:	37fd                	addiw	a5,a5,-1
    80005396:	1782                	slli	a5,a5,0x20
    80005398:	9381                	srli	a5,a5,0x20
    8000539a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000539e:	fff4c503          	lbu	a0,-1(s1)
    800053a2:	d9dff0ef          	jal	8000513e <consputc>
  while(--i >= 0)
    800053a6:	14fd                	addi	s1,s1,-1
    800053a8:	ff249be3          	bne	s1,s2,8000539e <printint+0x70>
    800053ac:	64e2                	ld	s1,24(sp)
    800053ae:	6942                	ld	s2,16(sp)
}
    800053b0:	70a2                	ld	ra,40(sp)
    800053b2:	7402                	ld	s0,32(sp)
    800053b4:	6145                	addi	sp,sp,48
    800053b6:	8082                	ret
    x = -xx;
    800053b8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800053bc:	4885                	li	a7,1
    x = -xx;
    800053be:	b741                	j	8000533e <printint+0x10>

00000000800053c0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800053c0:	7155                	addi	sp,sp,-208
    800053c2:	e506                	sd	ra,136(sp)
    800053c4:	e122                	sd	s0,128(sp)
    800053c6:	f0d2                	sd	s4,96(sp)
    800053c8:	0900                	addi	s0,sp,144
    800053ca:	8a2a                	mv	s4,a0
    800053cc:	e40c                	sd	a1,8(s0)
    800053ce:	e810                	sd	a2,16(s0)
    800053d0:	ec14                	sd	a3,24(s0)
    800053d2:	f018                	sd	a4,32(s0)
    800053d4:	f41c                	sd	a5,40(s0)
    800053d6:	03043823          	sd	a6,48(s0)
    800053da:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800053de:	00019797          	auipc	a5,0x19
    800053e2:	5e27a783          	lw	a5,1506(a5) # 8001e9c0 <pr+0x18>
    800053e6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800053ea:	e3a1                	bnez	a5,8000542a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800053ec:	00840793          	addi	a5,s0,8
    800053f0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053f4:	00054503          	lbu	a0,0(a0)
    800053f8:	26050763          	beqz	a0,80005666 <printf+0x2a6>
    800053fc:	fca6                	sd	s1,120(sp)
    800053fe:	f8ca                	sd	s2,112(sp)
    80005400:	f4ce                	sd	s3,104(sp)
    80005402:	ecd6                	sd	s5,88(sp)
    80005404:	e8da                	sd	s6,80(sp)
    80005406:	e0e2                	sd	s8,64(sp)
    80005408:	fc66                	sd	s9,56(sp)
    8000540a:	f86a                	sd	s10,48(sp)
    8000540c:	f46e                	sd	s11,40(sp)
    8000540e:	4981                	li	s3,0
    if(cx != '%'){
    80005410:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005414:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005418:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000541c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005420:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005424:	07000d93          	li	s11,112
    80005428:	a815                	j	8000545c <printf+0x9c>
    acquire(&pr.lock);
    8000542a:	00019517          	auipc	a0,0x19
    8000542e:	57e50513          	addi	a0,a0,1406 # 8001e9a8 <pr>
    80005432:	58e000ef          	jal	800059c0 <acquire>
  va_start(ap, fmt);
    80005436:	00840793          	addi	a5,s0,8
    8000543a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000543e:	000a4503          	lbu	a0,0(s4)
    80005442:	fd4d                	bnez	a0,800053fc <printf+0x3c>
    80005444:	a481                	j	80005684 <printf+0x2c4>
      consputc(cx);
    80005446:	cf9ff0ef          	jal	8000513e <consputc>
      continue;
    8000544a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000544c:	0014899b          	addiw	s3,s1,1
    80005450:	013a07b3          	add	a5,s4,s3
    80005454:	0007c503          	lbu	a0,0(a5)
    80005458:	1e050b63          	beqz	a0,8000564e <printf+0x28e>
    if(cx != '%'){
    8000545c:	ff5515e3          	bne	a0,s5,80005446 <printf+0x86>
    i++;
    80005460:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005464:	009a07b3          	add	a5,s4,s1
    80005468:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000546c:	1e090163          	beqz	s2,8000564e <printf+0x28e>
    80005470:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005474:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005476:	c789                	beqz	a5,80005480 <printf+0xc0>
    80005478:	009a0733          	add	a4,s4,s1
    8000547c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005480:	03690763          	beq	s2,s6,800054ae <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005484:	05890163          	beq	s2,s8,800054c6 <printf+0x106>
    } else if(c0 == 'u'){
    80005488:	0d990b63          	beq	s2,s9,8000555e <printf+0x19e>
    } else if(c0 == 'x'){
    8000548c:	13a90163          	beq	s2,s10,800055ae <printf+0x1ee>
    } else if(c0 == 'p'){
    80005490:	13b90b63          	beq	s2,s11,800055c6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005494:	07300793          	li	a5,115
    80005498:	16f90a63          	beq	s2,a5,8000560c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000549c:	1b590463          	beq	s2,s5,80005644 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800054a0:	8556                	mv	a0,s5
    800054a2:	c9dff0ef          	jal	8000513e <consputc>
      consputc(c0);
    800054a6:	854a                	mv	a0,s2
    800054a8:	c97ff0ef          	jal	8000513e <consputc>
    800054ac:	b745                	j	8000544c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800054ae:	f8843783          	ld	a5,-120(s0)
    800054b2:	00878713          	addi	a4,a5,8
    800054b6:	f8e43423          	sd	a4,-120(s0)
    800054ba:	4605                	li	a2,1
    800054bc:	45a9                	li	a1,10
    800054be:	4388                	lw	a0,0(a5)
    800054c0:	e6fff0ef          	jal	8000532e <printint>
    800054c4:	b761                	j	8000544c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800054c6:	03678663          	beq	a5,s6,800054f2 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800054ca:	05878263          	beq	a5,s8,8000550e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800054ce:	0b978463          	beq	a5,s9,80005576 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800054d2:	fda797e3          	bne	a5,s10,800054a0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800054d6:	f8843783          	ld	a5,-120(s0)
    800054da:	00878713          	addi	a4,a5,8
    800054de:	f8e43423          	sd	a4,-120(s0)
    800054e2:	4601                	li	a2,0
    800054e4:	45c1                	li	a1,16
    800054e6:	6388                	ld	a0,0(a5)
    800054e8:	e47ff0ef          	jal	8000532e <printint>
      i += 1;
    800054ec:	0029849b          	addiw	s1,s3,2
    800054f0:	bfb1                	j	8000544c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800054f2:	f8843783          	ld	a5,-120(s0)
    800054f6:	00878713          	addi	a4,a5,8
    800054fa:	f8e43423          	sd	a4,-120(s0)
    800054fe:	4605                	li	a2,1
    80005500:	45a9                	li	a1,10
    80005502:	6388                	ld	a0,0(a5)
    80005504:	e2bff0ef          	jal	8000532e <printint>
      i += 1;
    80005508:	0029849b          	addiw	s1,s3,2
    8000550c:	b781                	j	8000544c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000550e:	06400793          	li	a5,100
    80005512:	02f68863          	beq	a3,a5,80005542 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005516:	07500793          	li	a5,117
    8000551a:	06f68c63          	beq	a3,a5,80005592 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000551e:	07800793          	li	a5,120
    80005522:	f6f69fe3          	bne	a3,a5,800054a0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005526:	f8843783          	ld	a5,-120(s0)
    8000552a:	00878713          	addi	a4,a5,8
    8000552e:	f8e43423          	sd	a4,-120(s0)
    80005532:	4601                	li	a2,0
    80005534:	45c1                	li	a1,16
    80005536:	6388                	ld	a0,0(a5)
    80005538:	df7ff0ef          	jal	8000532e <printint>
      i += 2;
    8000553c:	0039849b          	addiw	s1,s3,3
    80005540:	b731                	j	8000544c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005542:	f8843783          	ld	a5,-120(s0)
    80005546:	00878713          	addi	a4,a5,8
    8000554a:	f8e43423          	sd	a4,-120(s0)
    8000554e:	4605                	li	a2,1
    80005550:	45a9                	li	a1,10
    80005552:	6388                	ld	a0,0(a5)
    80005554:	ddbff0ef          	jal	8000532e <printint>
      i += 2;
    80005558:	0039849b          	addiw	s1,s3,3
    8000555c:	bdc5                	j	8000544c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000555e:	f8843783          	ld	a5,-120(s0)
    80005562:	00878713          	addi	a4,a5,8
    80005566:	f8e43423          	sd	a4,-120(s0)
    8000556a:	4601                	li	a2,0
    8000556c:	45a9                	li	a1,10
    8000556e:	4388                	lw	a0,0(a5)
    80005570:	dbfff0ef          	jal	8000532e <printint>
    80005574:	bde1                	j	8000544c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005576:	f8843783          	ld	a5,-120(s0)
    8000557a:	00878713          	addi	a4,a5,8
    8000557e:	f8e43423          	sd	a4,-120(s0)
    80005582:	4601                	li	a2,0
    80005584:	45a9                	li	a1,10
    80005586:	6388                	ld	a0,0(a5)
    80005588:	da7ff0ef          	jal	8000532e <printint>
      i += 1;
    8000558c:	0029849b          	addiw	s1,s3,2
    80005590:	bd75                	j	8000544c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005592:	f8843783          	ld	a5,-120(s0)
    80005596:	00878713          	addi	a4,a5,8
    8000559a:	f8e43423          	sd	a4,-120(s0)
    8000559e:	4601                	li	a2,0
    800055a0:	45a9                	li	a1,10
    800055a2:	6388                	ld	a0,0(a5)
    800055a4:	d8bff0ef          	jal	8000532e <printint>
      i += 2;
    800055a8:	0039849b          	addiw	s1,s3,3
    800055ac:	b545                	j	8000544c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800055ae:	f8843783          	ld	a5,-120(s0)
    800055b2:	00878713          	addi	a4,a5,8
    800055b6:	f8e43423          	sd	a4,-120(s0)
    800055ba:	4601                	li	a2,0
    800055bc:	45c1                	li	a1,16
    800055be:	4388                	lw	a0,0(a5)
    800055c0:	d6fff0ef          	jal	8000532e <printint>
    800055c4:	b561                	j	8000544c <printf+0x8c>
    800055c6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800055c8:	f8843783          	ld	a5,-120(s0)
    800055cc:	00878713          	addi	a4,a5,8
    800055d0:	f8e43423          	sd	a4,-120(s0)
    800055d4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800055d8:	03000513          	li	a0,48
    800055dc:	b63ff0ef          	jal	8000513e <consputc>
  consputc('x');
    800055e0:	07800513          	li	a0,120
    800055e4:	b5bff0ef          	jal	8000513e <consputc>
    800055e8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800055ea:	00002b97          	auipc	s7,0x2
    800055ee:	286b8b93          	addi	s7,s7,646 # 80007870 <digits>
    800055f2:	03c9d793          	srli	a5,s3,0x3c
    800055f6:	97de                	add	a5,a5,s7
    800055f8:	0007c503          	lbu	a0,0(a5)
    800055fc:	b43ff0ef          	jal	8000513e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005600:	0992                	slli	s3,s3,0x4
    80005602:	397d                	addiw	s2,s2,-1
    80005604:	fe0917e3          	bnez	s2,800055f2 <printf+0x232>
    80005608:	6ba6                	ld	s7,72(sp)
    8000560a:	b589                	j	8000544c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000560c:	f8843783          	ld	a5,-120(s0)
    80005610:	00878713          	addi	a4,a5,8
    80005614:	f8e43423          	sd	a4,-120(s0)
    80005618:	0007b903          	ld	s2,0(a5)
    8000561c:	00090d63          	beqz	s2,80005636 <printf+0x276>
      for(; *s; s++)
    80005620:	00094503          	lbu	a0,0(s2)
    80005624:	e20504e3          	beqz	a0,8000544c <printf+0x8c>
        consputc(*s);
    80005628:	b17ff0ef          	jal	8000513e <consputc>
      for(; *s; s++)
    8000562c:	0905                	addi	s2,s2,1
    8000562e:	00094503          	lbu	a0,0(s2)
    80005632:	f97d                	bnez	a0,80005628 <printf+0x268>
    80005634:	bd21                	j	8000544c <printf+0x8c>
        s = "(null)";
    80005636:	00002917          	auipc	s2,0x2
    8000563a:	0e290913          	addi	s2,s2,226 # 80007718 <etext+0x718>
      for(; *s; s++)
    8000563e:	02800513          	li	a0,40
    80005642:	b7dd                	j	80005628 <printf+0x268>
      consputc('%');
    80005644:	02500513          	li	a0,37
    80005648:	af7ff0ef          	jal	8000513e <consputc>
    8000564c:	b501                	j	8000544c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000564e:	f7843783          	ld	a5,-136(s0)
    80005652:	e385                	bnez	a5,80005672 <printf+0x2b2>
    80005654:	74e6                	ld	s1,120(sp)
    80005656:	7946                	ld	s2,112(sp)
    80005658:	79a6                	ld	s3,104(sp)
    8000565a:	6ae6                	ld	s5,88(sp)
    8000565c:	6b46                	ld	s6,80(sp)
    8000565e:	6c06                	ld	s8,64(sp)
    80005660:	7ce2                	ld	s9,56(sp)
    80005662:	7d42                	ld	s10,48(sp)
    80005664:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005666:	4501                	li	a0,0
    80005668:	60aa                	ld	ra,136(sp)
    8000566a:	640a                	ld	s0,128(sp)
    8000566c:	7a06                	ld	s4,96(sp)
    8000566e:	6169                	addi	sp,sp,208
    80005670:	8082                	ret
    80005672:	74e6                	ld	s1,120(sp)
    80005674:	7946                	ld	s2,112(sp)
    80005676:	79a6                	ld	s3,104(sp)
    80005678:	6ae6                	ld	s5,88(sp)
    8000567a:	6b46                	ld	s6,80(sp)
    8000567c:	6c06                	ld	s8,64(sp)
    8000567e:	7ce2                	ld	s9,56(sp)
    80005680:	7d42                	ld	s10,48(sp)
    80005682:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005684:	00019517          	auipc	a0,0x19
    80005688:	32450513          	addi	a0,a0,804 # 8001e9a8 <pr>
    8000568c:	3cc000ef          	jal	80005a58 <release>
    80005690:	bfd9                	j	80005666 <printf+0x2a6>

0000000080005692 <panic>:

void
panic(char *s)
{
    80005692:	1101                	addi	sp,sp,-32
    80005694:	ec06                	sd	ra,24(sp)
    80005696:	e822                	sd	s0,16(sp)
    80005698:	e426                	sd	s1,8(sp)
    8000569a:	1000                	addi	s0,sp,32
    8000569c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000569e:	00019797          	auipc	a5,0x19
    800056a2:	3207a123          	sw	zero,802(a5) # 8001e9c0 <pr+0x18>
  printf("panic: ");
    800056a6:	00002517          	auipc	a0,0x2
    800056aa:	07a50513          	addi	a0,a0,122 # 80007720 <etext+0x720>
    800056ae:	d13ff0ef          	jal	800053c0 <printf>
  printf("%s\n", s);
    800056b2:	85a6                	mv	a1,s1
    800056b4:	00002517          	auipc	a0,0x2
    800056b8:	07450513          	addi	a0,a0,116 # 80007728 <etext+0x728>
    800056bc:	d05ff0ef          	jal	800053c0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800056c0:	4785                	li	a5,1
    800056c2:	00005717          	auipc	a4,0x5
    800056c6:	bef72523          	sw	a5,-1046(a4) # 8000a2ac <panicked>
  for(;;)
    800056ca:	a001                	j	800056ca <panic+0x38>

00000000800056cc <printfinit>:
    ;
}

void
printfinit(void)
{
    800056cc:	1101                	addi	sp,sp,-32
    800056ce:	ec06                	sd	ra,24(sp)
    800056d0:	e822                	sd	s0,16(sp)
    800056d2:	e426                	sd	s1,8(sp)
    800056d4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800056d6:	00019497          	auipc	s1,0x19
    800056da:	2d248493          	addi	s1,s1,722 # 8001e9a8 <pr>
    800056de:	00002597          	auipc	a1,0x2
    800056e2:	05258593          	addi	a1,a1,82 # 80007730 <etext+0x730>
    800056e6:	8526                	mv	a0,s1
    800056e8:	258000ef          	jal	80005940 <initlock>
  pr.locking = 1;
    800056ec:	4785                	li	a5,1
    800056ee:	cc9c                	sw	a5,24(s1)
}
    800056f0:	60e2                	ld	ra,24(sp)
    800056f2:	6442                	ld	s0,16(sp)
    800056f4:	64a2                	ld	s1,8(sp)
    800056f6:	6105                	addi	sp,sp,32
    800056f8:	8082                	ret

00000000800056fa <uartinit>:

void uartstart();

void
uartinit(void)
{
    800056fa:	1141                	addi	sp,sp,-16
    800056fc:	e406                	sd	ra,8(sp)
    800056fe:	e022                	sd	s0,0(sp)
    80005700:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005702:	100007b7          	lui	a5,0x10000
    80005706:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000570a:	10000737          	lui	a4,0x10000
    8000570e:	f8000693          	li	a3,-128
    80005712:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005716:	468d                	li	a3,3
    80005718:	10000637          	lui	a2,0x10000
    8000571c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005720:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005724:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005728:	10000737          	lui	a4,0x10000
    8000572c:	461d                	li	a2,7
    8000572e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005732:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005736:	00002597          	auipc	a1,0x2
    8000573a:	00258593          	addi	a1,a1,2 # 80007738 <etext+0x738>
    8000573e:	00019517          	auipc	a0,0x19
    80005742:	28a50513          	addi	a0,a0,650 # 8001e9c8 <uart_tx_lock>
    80005746:	1fa000ef          	jal	80005940 <initlock>
}
    8000574a:	60a2                	ld	ra,8(sp)
    8000574c:	6402                	ld	s0,0(sp)
    8000574e:	0141                	addi	sp,sp,16
    80005750:	8082                	ret

0000000080005752 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005752:	1101                	addi	sp,sp,-32
    80005754:	ec06                	sd	ra,24(sp)
    80005756:	e822                	sd	s0,16(sp)
    80005758:	e426                	sd	s1,8(sp)
    8000575a:	1000                	addi	s0,sp,32
    8000575c:	84aa                	mv	s1,a0
  push_off();
    8000575e:	222000ef          	jal	80005980 <push_off>

  if(panicked){
    80005762:	00005797          	auipc	a5,0x5
    80005766:	b4a7a783          	lw	a5,-1206(a5) # 8000a2ac <panicked>
    8000576a:	e795                	bnez	a5,80005796 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000576c:	10000737          	lui	a4,0x10000
    80005770:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005772:	00074783          	lbu	a5,0(a4)
    80005776:	0207f793          	andi	a5,a5,32
    8000577a:	dfe5                	beqz	a5,80005772 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000577c:	0ff4f513          	zext.b	a0,s1
    80005780:	100007b7          	lui	a5,0x10000
    80005784:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005788:	27c000ef          	jal	80005a04 <pop_off>
}
    8000578c:	60e2                	ld	ra,24(sp)
    8000578e:	6442                	ld	s0,16(sp)
    80005790:	64a2                	ld	s1,8(sp)
    80005792:	6105                	addi	sp,sp,32
    80005794:	8082                	ret
    for(;;)
    80005796:	a001                	j	80005796 <uartputc_sync+0x44>

0000000080005798 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005798:	00005797          	auipc	a5,0x5
    8000579c:	b187b783          	ld	a5,-1256(a5) # 8000a2b0 <uart_tx_r>
    800057a0:	00005717          	auipc	a4,0x5
    800057a4:	b1873703          	ld	a4,-1256(a4) # 8000a2b8 <uart_tx_w>
    800057a8:	08f70263          	beq	a4,a5,8000582c <uartstart+0x94>
{
    800057ac:	7139                	addi	sp,sp,-64
    800057ae:	fc06                	sd	ra,56(sp)
    800057b0:	f822                	sd	s0,48(sp)
    800057b2:	f426                	sd	s1,40(sp)
    800057b4:	f04a                	sd	s2,32(sp)
    800057b6:	ec4e                	sd	s3,24(sp)
    800057b8:	e852                	sd	s4,16(sp)
    800057ba:	e456                	sd	s5,8(sp)
    800057bc:	e05a                	sd	s6,0(sp)
    800057be:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800057c0:	10000937          	lui	s2,0x10000
    800057c4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800057c6:	00019a97          	auipc	s5,0x19
    800057ca:	202a8a93          	addi	s5,s5,514 # 8001e9c8 <uart_tx_lock>
    uart_tx_r += 1;
    800057ce:	00005497          	auipc	s1,0x5
    800057d2:	ae248493          	addi	s1,s1,-1310 # 8000a2b0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800057d6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800057da:	00005997          	auipc	s3,0x5
    800057de:	ade98993          	addi	s3,s3,-1314 # 8000a2b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800057e2:	00094703          	lbu	a4,0(s2)
    800057e6:	02077713          	andi	a4,a4,32
    800057ea:	c71d                	beqz	a4,80005818 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800057ec:	01f7f713          	andi	a4,a5,31
    800057f0:	9756                	add	a4,a4,s5
    800057f2:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800057f6:	0785                	addi	a5,a5,1
    800057f8:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800057fa:	8526                	mv	a0,s1
    800057fc:	b85fb0ef          	jal	80001380 <wakeup>
    WriteReg(THR, c);
    80005800:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005804:	609c                	ld	a5,0(s1)
    80005806:	0009b703          	ld	a4,0(s3)
    8000580a:	fcf71ce3          	bne	a4,a5,800057e2 <uartstart+0x4a>
      ReadReg(ISR);
    8000580e:	100007b7          	lui	a5,0x10000
    80005812:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005814:	0007c783          	lbu	a5,0(a5)
  }
}
    80005818:	70e2                	ld	ra,56(sp)
    8000581a:	7442                	ld	s0,48(sp)
    8000581c:	74a2                	ld	s1,40(sp)
    8000581e:	7902                	ld	s2,32(sp)
    80005820:	69e2                	ld	s3,24(sp)
    80005822:	6a42                	ld	s4,16(sp)
    80005824:	6aa2                	ld	s5,8(sp)
    80005826:	6b02                	ld	s6,0(sp)
    80005828:	6121                	addi	sp,sp,64
    8000582a:	8082                	ret
      ReadReg(ISR);
    8000582c:	100007b7          	lui	a5,0x10000
    80005830:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005832:	0007c783          	lbu	a5,0(a5)
      return;
    80005836:	8082                	ret

0000000080005838 <uartputc>:
{
    80005838:	7179                	addi	sp,sp,-48
    8000583a:	f406                	sd	ra,40(sp)
    8000583c:	f022                	sd	s0,32(sp)
    8000583e:	ec26                	sd	s1,24(sp)
    80005840:	e84a                	sd	s2,16(sp)
    80005842:	e44e                	sd	s3,8(sp)
    80005844:	e052                	sd	s4,0(sp)
    80005846:	1800                	addi	s0,sp,48
    80005848:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000584a:	00019517          	auipc	a0,0x19
    8000584e:	17e50513          	addi	a0,a0,382 # 8001e9c8 <uart_tx_lock>
    80005852:	16e000ef          	jal	800059c0 <acquire>
  if(panicked){
    80005856:	00005797          	auipc	a5,0x5
    8000585a:	a567a783          	lw	a5,-1450(a5) # 8000a2ac <panicked>
    8000585e:	efbd                	bnez	a5,800058dc <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005860:	00005717          	auipc	a4,0x5
    80005864:	a5873703          	ld	a4,-1448(a4) # 8000a2b8 <uart_tx_w>
    80005868:	00005797          	auipc	a5,0x5
    8000586c:	a487b783          	ld	a5,-1464(a5) # 8000a2b0 <uart_tx_r>
    80005870:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005874:	00019997          	auipc	s3,0x19
    80005878:	15498993          	addi	s3,s3,340 # 8001e9c8 <uart_tx_lock>
    8000587c:	00005497          	auipc	s1,0x5
    80005880:	a3448493          	addi	s1,s1,-1484 # 8000a2b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005884:	00005917          	auipc	s2,0x5
    80005888:	a3490913          	addi	s2,s2,-1484 # 8000a2b8 <uart_tx_w>
    8000588c:	00e79d63          	bne	a5,a4,800058a6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005890:	85ce                	mv	a1,s3
    80005892:	8526                	mv	a0,s1
    80005894:	aa1fb0ef          	jal	80001334 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005898:	00093703          	ld	a4,0(s2)
    8000589c:	609c                	ld	a5,0(s1)
    8000589e:	02078793          	addi	a5,a5,32
    800058a2:	fee787e3          	beq	a5,a4,80005890 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800058a6:	00019497          	auipc	s1,0x19
    800058aa:	12248493          	addi	s1,s1,290 # 8001e9c8 <uart_tx_lock>
    800058ae:	01f77793          	andi	a5,a4,31
    800058b2:	97a6                	add	a5,a5,s1
    800058b4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800058b8:	0705                	addi	a4,a4,1
    800058ba:	00005797          	auipc	a5,0x5
    800058be:	9ee7bf23          	sd	a4,-1538(a5) # 8000a2b8 <uart_tx_w>
  uartstart();
    800058c2:	ed7ff0ef          	jal	80005798 <uartstart>
  release(&uart_tx_lock);
    800058c6:	8526                	mv	a0,s1
    800058c8:	190000ef          	jal	80005a58 <release>
}
    800058cc:	70a2                	ld	ra,40(sp)
    800058ce:	7402                	ld	s0,32(sp)
    800058d0:	64e2                	ld	s1,24(sp)
    800058d2:	6942                	ld	s2,16(sp)
    800058d4:	69a2                	ld	s3,8(sp)
    800058d6:	6a02                	ld	s4,0(sp)
    800058d8:	6145                	addi	sp,sp,48
    800058da:	8082                	ret
    for(;;)
    800058dc:	a001                	j	800058dc <uartputc+0xa4>

00000000800058de <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800058de:	1141                	addi	sp,sp,-16
    800058e0:	e422                	sd	s0,8(sp)
    800058e2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800058e4:	100007b7          	lui	a5,0x10000
    800058e8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800058ea:	0007c783          	lbu	a5,0(a5)
    800058ee:	8b85                	andi	a5,a5,1
    800058f0:	cb81                	beqz	a5,80005900 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800058f2:	100007b7          	lui	a5,0x10000
    800058f6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800058fa:	6422                	ld	s0,8(sp)
    800058fc:	0141                	addi	sp,sp,16
    800058fe:	8082                	ret
    return -1;
    80005900:	557d                	li	a0,-1
    80005902:	bfe5                	j	800058fa <uartgetc+0x1c>

0000000080005904 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005904:	1101                	addi	sp,sp,-32
    80005906:	ec06                	sd	ra,24(sp)
    80005908:	e822                	sd	s0,16(sp)
    8000590a:	e426                	sd	s1,8(sp)
    8000590c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000590e:	54fd                	li	s1,-1
    80005910:	a019                	j	80005916 <uartintr+0x12>
      break;
    consoleintr(c);
    80005912:	85fff0ef          	jal	80005170 <consoleintr>
    int c = uartgetc();
    80005916:	fc9ff0ef          	jal	800058de <uartgetc>
    if(c == -1)
    8000591a:	fe951ce3          	bne	a0,s1,80005912 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000591e:	00019497          	auipc	s1,0x19
    80005922:	0aa48493          	addi	s1,s1,170 # 8001e9c8 <uart_tx_lock>
    80005926:	8526                	mv	a0,s1
    80005928:	098000ef          	jal	800059c0 <acquire>
  uartstart();
    8000592c:	e6dff0ef          	jal	80005798 <uartstart>
  release(&uart_tx_lock);
    80005930:	8526                	mv	a0,s1
    80005932:	126000ef          	jal	80005a58 <release>
}
    80005936:	60e2                	ld	ra,24(sp)
    80005938:	6442                	ld	s0,16(sp)
    8000593a:	64a2                	ld	s1,8(sp)
    8000593c:	6105                	addi	sp,sp,32
    8000593e:	8082                	ret

0000000080005940 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005940:	1141                	addi	sp,sp,-16
    80005942:	e422                	sd	s0,8(sp)
    80005944:	0800                	addi	s0,sp,16
  lk->name = name;
    80005946:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005948:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000594c:	00053823          	sd	zero,16(a0)
}
    80005950:	6422                	ld	s0,8(sp)
    80005952:	0141                	addi	sp,sp,16
    80005954:	8082                	ret

0000000080005956 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005956:	411c                	lw	a5,0(a0)
    80005958:	e399                	bnez	a5,8000595e <holding+0x8>
    8000595a:	4501                	li	a0,0
  return r;
}
    8000595c:	8082                	ret
{
    8000595e:	1101                	addi	sp,sp,-32
    80005960:	ec06                	sd	ra,24(sp)
    80005962:	e822                	sd	s0,16(sp)
    80005964:	e426                	sd	s1,8(sp)
    80005966:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005968:	6904                	ld	s1,16(a0)
    8000596a:	be0fb0ef          	jal	80000d4a <mycpu>
    8000596e:	40a48533          	sub	a0,s1,a0
    80005972:	00153513          	seqz	a0,a0
}
    80005976:	60e2                	ld	ra,24(sp)
    80005978:	6442                	ld	s0,16(sp)
    8000597a:	64a2                	ld	s1,8(sp)
    8000597c:	6105                	addi	sp,sp,32
    8000597e:	8082                	ret

0000000080005980 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005980:	1101                	addi	sp,sp,-32
    80005982:	ec06                	sd	ra,24(sp)
    80005984:	e822                	sd	s0,16(sp)
    80005986:	e426                	sd	s1,8(sp)
    80005988:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000598a:	100024f3          	csrr	s1,sstatus
    8000598e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005992:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005994:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005998:	bb2fb0ef          	jal	80000d4a <mycpu>
    8000599c:	5d3c                	lw	a5,120(a0)
    8000599e:	cb99                	beqz	a5,800059b4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800059a0:	baafb0ef          	jal	80000d4a <mycpu>
    800059a4:	5d3c                	lw	a5,120(a0)
    800059a6:	2785                	addiw	a5,a5,1
    800059a8:	dd3c                	sw	a5,120(a0)
}
    800059aa:	60e2                	ld	ra,24(sp)
    800059ac:	6442                	ld	s0,16(sp)
    800059ae:	64a2                	ld	s1,8(sp)
    800059b0:	6105                	addi	sp,sp,32
    800059b2:	8082                	ret
    mycpu()->intena = old;
    800059b4:	b96fb0ef          	jal	80000d4a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800059b8:	8085                	srli	s1,s1,0x1
    800059ba:	8885                	andi	s1,s1,1
    800059bc:	dd64                	sw	s1,124(a0)
    800059be:	b7cd                	j	800059a0 <push_off+0x20>

00000000800059c0 <acquire>:
{
    800059c0:	1101                	addi	sp,sp,-32
    800059c2:	ec06                	sd	ra,24(sp)
    800059c4:	e822                	sd	s0,16(sp)
    800059c6:	e426                	sd	s1,8(sp)
    800059c8:	1000                	addi	s0,sp,32
    800059ca:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800059cc:	fb5ff0ef          	jal	80005980 <push_off>
  if(holding(lk))
    800059d0:	8526                	mv	a0,s1
    800059d2:	f85ff0ef          	jal	80005956 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800059d6:	4705                	li	a4,1
  if(holding(lk))
    800059d8:	e105                	bnez	a0,800059f8 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800059da:	87ba                	mv	a5,a4
    800059dc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800059e0:	2781                	sext.w	a5,a5
    800059e2:	ffe5                	bnez	a5,800059da <acquire+0x1a>
  __sync_synchronize();
    800059e4:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800059e8:	b62fb0ef          	jal	80000d4a <mycpu>
    800059ec:	e888                	sd	a0,16(s1)
}
    800059ee:	60e2                	ld	ra,24(sp)
    800059f0:	6442                	ld	s0,16(sp)
    800059f2:	64a2                	ld	s1,8(sp)
    800059f4:	6105                	addi	sp,sp,32
    800059f6:	8082                	ret
    panic("acquire");
    800059f8:	00002517          	auipc	a0,0x2
    800059fc:	d4850513          	addi	a0,a0,-696 # 80007740 <etext+0x740>
    80005a00:	c93ff0ef          	jal	80005692 <panic>

0000000080005a04 <pop_off>:

void
pop_off(void)
{
    80005a04:	1141                	addi	sp,sp,-16
    80005a06:	e406                	sd	ra,8(sp)
    80005a08:	e022                	sd	s0,0(sp)
    80005a0a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005a0c:	b3efb0ef          	jal	80000d4a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a10:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005a14:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005a16:	e78d                	bnez	a5,80005a40 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005a18:	5d3c                	lw	a5,120(a0)
    80005a1a:	02f05963          	blez	a5,80005a4c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005a1e:	37fd                	addiw	a5,a5,-1
    80005a20:	0007871b          	sext.w	a4,a5
    80005a24:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005a26:	eb09                	bnez	a4,80005a38 <pop_off+0x34>
    80005a28:	5d7c                	lw	a5,124(a0)
    80005a2a:	c799                	beqz	a5,80005a38 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a2c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005a30:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005a34:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005a38:	60a2                	ld	ra,8(sp)
    80005a3a:	6402                	ld	s0,0(sp)
    80005a3c:	0141                	addi	sp,sp,16
    80005a3e:	8082                	ret
    panic("pop_off - interruptible");
    80005a40:	00002517          	auipc	a0,0x2
    80005a44:	d0850513          	addi	a0,a0,-760 # 80007748 <etext+0x748>
    80005a48:	c4bff0ef          	jal	80005692 <panic>
    panic("pop_off");
    80005a4c:	00002517          	auipc	a0,0x2
    80005a50:	d1450513          	addi	a0,a0,-748 # 80007760 <etext+0x760>
    80005a54:	c3fff0ef          	jal	80005692 <panic>

0000000080005a58 <release>:
{
    80005a58:	1101                	addi	sp,sp,-32
    80005a5a:	ec06                	sd	ra,24(sp)
    80005a5c:	e822                	sd	s0,16(sp)
    80005a5e:	e426                	sd	s1,8(sp)
    80005a60:	1000                	addi	s0,sp,32
    80005a62:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005a64:	ef3ff0ef          	jal	80005956 <holding>
    80005a68:	c105                	beqz	a0,80005a88 <release+0x30>
  lk->cpu = 0;
    80005a6a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005a6e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005a72:	0310000f          	fence	rw,w
    80005a76:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005a7a:	f8bff0ef          	jal	80005a04 <pop_off>
}
    80005a7e:	60e2                	ld	ra,24(sp)
    80005a80:	6442                	ld	s0,16(sp)
    80005a82:	64a2                	ld	s1,8(sp)
    80005a84:	6105                	addi	sp,sp,32
    80005a86:	8082                	ret
    panic("release");
    80005a88:	00002517          	auipc	a0,0x2
    80005a8c:	ce050513          	addi	a0,a0,-800 # 80007768 <etext+0x768>
    80005a90:	c03ff0ef          	jal	80005692 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
