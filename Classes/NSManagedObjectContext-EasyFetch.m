/** Core Data Easy Fetch Category
 *
 * This is an Objective-C category for Core Data (`NSManagedObjectContext
 * (EasyFetch)`) that offers a few useful functions added that simplify [Core
 * Data][1] programming for Mac OS X and iPhone OS. It's based loosely on
 * [code][2] by Matt Gallagher, but with several enhancements and modifications
 * that I needed for a project I was writing that used Core Data.
 *
 * 1: http://developer.apple.com/mac/library/DOCUMENTATION/Cocoa/Conceptual/CoreData/index.html
 * 2: http://cocoawithlove.com/2008/03/core-data-one-line-fetch.html
 */
/** Copyright &copy; 2009, 2010 Austin Ziegler
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "NSManagedObjectContext-EasyFetch.h"

@implementation NSManagedObjectContext (EasyFetch)

/** @brief Convenience method to fetch one object for a given Entity name and predicate.  
 * This assumes it will only return one item so make sure your logic is sound.
 * 
 */
- (id)fetchSingleForEntityName:(NSString*)entityName
				 predicateWithFormat:(NSString*)predicateFormat, ... 
{
	
	va_list variadicArguments;
	va_start(variadicArguments, predicateFormat);
	NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
													arguments:variadicArguments];
	va_end(variadicArguments);
	
	NSArray* resultsArray = [self fetchObjectsForEntityName:entityName withPredicate:predicate];
	
	
	if ([resultsArray count] == 1) {
		return [resultsArray objectAtIndex:0];
	}
	
	return nil;
}

- (id)fetchSingleObjectForEntityName:(NSString*)entityName {
	
	NSArray *resultsArray = [self fetchObjectsForEntityName:entityName];
	
	if ([resultsArray count] == 1) {
		return [resultsArray objectAtIndex:0];
	}
	
	return nil;
	
}



#pragma mark -
#pragma mark Get Fetch Count

- (NSUInteger)countFetchObjectsForEntityName:(NSString*)entityName predicateWithFormat:(NSString*)predicateFormat, ...
{
	va_list variadicArguments;
	va_start(variadicArguments, predicateFormat);
	NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
													arguments:variadicArguments];
	va_end(variadicArguments);

	NSEntityDescription* entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:self];
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entity];
	
	if (predicate)
	{
		[request setPredicate:predicate];
	}
	
	NSError* error = nil;
	NSUInteger resultCount = [self countForFetchRequest:request error:&error];
	
	if (error != nil)
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NSException raise:NSGenericException format:@"%@", [error description]];
	}
	
	[request release];
	return resultCount;
	
}

#pragma mark -
#pragma mark Delete all objects

- (void) deleteAllObjectsForEntityName: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
	
    NSError *error;
    NSArray *items = [self executeFetchRequest:fetchRequest error:&error];
	
    for (NSManagedObject *managedObject in items) {
        [self deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![self save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
	[fetchRequest release];
	
}

- (void)deleteObjectsForEntityName:(NSString*)entityName
				   predicateWithFormat:(NSString*)predicateFormat, ...
{
	va_list variadicArguments;
	va_start(variadicArguments, predicateFormat);
	NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
													arguments:variadicArguments];
	va_end(variadicArguments);
	
	NSArray* items = [self fetchObjectsForEntityName:entityName withPredicate:predicate];
	
	for (NSManagedObject * object in items) {
		[self deleteObject:object];
	}
	
}
#pragma mark -
#pragma mark Fetch all unsorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
{
  return [self fetchObjectsForEntityName:entityName sortWith:nil
                           withPredicate:nil];
}

#pragma mark -
#pragma mark Fetch all sorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
{
  return [self fetchObjectsForEntityName:entityName sortByKey:key
                               ascending:ascending withPredicate:nil];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
{
  return [self fetchObjectsForEntityName:entityName sortWith:sortDescriptors
                           withPredicate:nil];
}

#pragma mark -
#pragma mark Fetch filtered unsorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                        withPredicate:(NSPredicate*)predicate
{
  return [self fetchObjectsForEntityName:entityName sortWith:nil
                           withPredicate:predicate];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                  predicateWithFormat:(NSString*)predicateFormat, ...
{
  va_list variadicArguments;
  va_start(variadicArguments, predicateFormat);
  NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
                                                  arguments:variadicArguments];
  va_end(variadicArguments);

  return [self fetchObjectsForEntityName:entityName sortWith:nil
                           withPredicate:predicate];
}

#pragma mark -
#pragma mark Fetch filtered sorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                        withPredicate:(NSPredicate*)predicate
{
  NSSortDescriptor* sort = [[[NSSortDescriptor alloc] initWithKey:key
                                                        ascending:ascending]
                                                        autorelease];

  return [self fetchObjectsForEntityName:entityName sortWith:[NSArray
                         arrayWithObject:sort] withPredicate:predicate];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
                        withPredicate:(NSPredicate*)predicate
{
  NSEntityDescription* entity = [NSEntityDescription entityForName:entityName
                                            inManagedObjectContext:self];
  NSFetchRequest* request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];

  if (predicate)
  {
    [request setPredicate:predicate];
  }

  if (sortDescriptors)
  {
    [request setSortDescriptors:sortDescriptors];
  }

  NSError* error = nil;
  NSArray* results = [self executeFetchRequest:request error:&error];

  if (error != nil)
  {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NSException raise:NSGenericException format:@"%@", [error description]];
  }

	[request release];
  return results;
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                  predicateWithFormat:(NSString*)predicateFormat, ...
{
  va_list variadicArguments;
  va_start(variadicArguments, predicateFormat);
  NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
                                                  arguments:variadicArguments];
  va_end(variadicArguments);

  return [self fetchObjectsForEntityName:entityName sortByKey:key
                               ascending:ascending withPredicate:predicate];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
                  predicateWithFormat:(NSString*)predicateFormat, ...
{
  va_list variadicArguments;
  va_start(variadicArguments, predicateFormat);
  NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
                                                  arguments:variadicArguments];
  va_end(variadicArguments);

  return [self fetchObjectsForEntityName:entityName sortWith:sortDescriptors
                           withPredicate:predicate];
}
@end
